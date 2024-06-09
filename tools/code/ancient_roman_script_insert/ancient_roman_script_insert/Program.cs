using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;
using System.Threading.Tasks;

namespace ancient_roman_script_insert
{
    class Program
    {
        static int GetCurWidth(string line, Dictionary<string, int> widths)
        {
            int cur_len = 0;
            foreach (char letter in line)
            {
                if (letter == '\n')
                {
                    int beep = 0;
                }
                else if (widths.ContainsKey(letter.ToString()))
                {
                    cur_len += widths[letter.ToString()];
                }
                else
                {
                    cur_len += 20;
                }
            }

            return cur_len;
        }
        static string Format(string line, int max_len, Dictionary<string, int> widths)
        {
            string outme = "";
            int cur_len = 0;
            int maxHardLen = 99;

            string[] splitRs = line.Split(new string[] { "\\n" }, StringSplitOptions.RemoveEmptyEntries);
            for (int r = 0; r < splitRs.Length; r++)
            {
                string[] pieces = splitRs[r].Split(new char[] { ' ' }, StringSplitOptions.RemoveEmptyEntries);
                string formatted = "";
                int line_cnt = 1;
                for (int k = 0; k < pieces.Length; k++)
                {
                    if (GetCurWidth(formatted + pieces[k].Replace("カイ", "WWWWW") + " ", widths) < max_len && (formatted.Replace("カイ:", "WWWWW:") + pieces[k] + " ").Length < maxHardLen)
                    {
                        formatted += pieces[k] + " ";
                    }
                    else
                    {
                        line_cnt++;
                        outme += formatted.Replace("\n", "\\n").Trim() + "\\n";
                        formatted = pieces[k] + " ";
                    }
                }
                outme += formatted.Replace("\n", "\\n").Trim();

                if (r + 1 != splitRs.Length)
                    outme += " \\n";
            }

            return outme.Trim();
        }

        static string GetEncodedLine(byte[] theLine, Dictionary<string, string> table)
        {
            int pos = 0;
            bool found = false;
            bool isLetter = false;
            string myLine = "";

            int maxTbleValLen = table.Keys.OrderByDescending(x => x.ToString().Length).First().Length / 2;

            while (pos < theLine.Length)
            {
                found = false;
                // Get largest letter...
                for (int i = maxTbleValLen; i >= 1; i--)
                {
                    if (pos + i < theLine.Length)
                    {
                        string key = BitConverter.ToString(theLine, pos, i).Replace("-", "");
                        if (table.ContainsKey(key))
                        {
                            if (!isLetter)
                            {
                                if (pos != 0)
                                {
                                    myLine += "\n";
                                }
                                myLine += "//";
                            }

                            myLine += table[key];
                            pos += i;
                            found = true;
                            isLetter = true;
                            break;
                        }
                    }

                    found = false;
                }

                if (!found)
                {
                    if (isLetter)
                    {
                        myLine += "\n";
                    }

                    myLine += "<$" + theLine[pos].ToString("X2") + ">";
                    pos++;

                    isLetter = false;
                }
            }

            return myLine;
        }

        static int longestEntry = 1;
        static byte[] Encode(string text, Dictionary<string, string> table)
        {
            List<byte> encoding = new List<byte>();
            for (int i = 0; i < text.Length; i++)
            {
                if (text[i] == '<' && ((i + 1) < text.Length && text[i + 1] == '$'))
                {
                    string hex = text.Substring(i + 2, 2);
                    encoding.Add(Convert.ToByte(hex, 16));
                    i += (5 - 1);
                }
                else
                {
                    for (int j = longestEntry; j >= 1; j--)
                    {
                        if (i + (j - 1) < text.Length)
                        {
                            string piece = text.Substring(i, j);
                            if (table.ContainsKey(piece))
                            {
                                string entry = table[piece];
                                for (int k = 0; k < entry.Length / 2; k++)
                                {
                                    string hex = entry.Substring(k * 2, 2);
                                    encoding.Add(Convert.ToByte(hex, 16));
                                }

                                i += (j - 1);
                                break;
                            }
                            else
                            {
                                int break_me = 0;
                            }

                        }
                    }
                }
            }
            return encoding.ToArray();
        }

        static List<PoEntry> ParseTranslatedScriptFile(string TranslatedScriptFile)
        {
            List<PoEntry> poEntries = new List<PoEntry>();

            Regex regex = new Regex("\"(.*)\"");

            string pos = "";
            string japanese = "";
            bool japaneseFound = false;
            string english = "";
            bool englishFound = false;
            string[] translatedLines = File.ReadAllLines(TranslatedScriptFile);
            for (int i = 0; i < translatedLines.Length; i++)
            {
                string translatedLine = translatedLines[i];
                if (translatedLine.StartsWith("#:"))
                {
                    pos = translatedLine.Replace("#: ", "");
                }
                else if (translatedLine.StartsWith("msgid"))
                {
                    japanese = "";
                    for (int j = i; j < translatedLines.Length; j++)
                    {
                        string line = regex.Match(translatedLines[j]).Value;
                        japanese += line.Substring(1, line.Length - 2);

                        if (j + 1 < translatedLines.Length && !translatedLines[j + 1].StartsWith("\""))
                        {
                            japaneseFound = true;
                            i = j;
                            break;
                        }
                    }
                }
                else if (translatedLine.StartsWith("msgstr"))
                {
                    english = "";
                    for (int j = i; j < translatedLines.Length; j++)
                    {
                        string line = regex.Match(translatedLines[j]).Value;
                        english += line.Substring(1, line.Length - 2);

                        if ((j + 1 < translatedLines.Length && !translatedLines[j + 1].StartsWith("\"")) || (j + 1 >= translatedLines.Length))
                        {
                            englishFound = true;
                            i = j;
                            break;
                        }
                    }
                }

                if (englishFound == true && japaneseFound == true)
                {
                    if (!String.IsNullOrEmpty(japanese) && !String.IsNullOrEmpty(english))
                    {
                        poEntries.Add(new PoEntry()
                        {
                            pos = pos,
                            japanese = japanese.Replace("\\\"", "\""),
                            english = english.Replace("\\\"", "\"").Replace("Kai", "カイ"),
                        });
                    }

                    pos = "";
                    japanese = "";
                    english = "";
                    japaneseFound = false;
                    englishFound = false;
                }

            }

            return poEntries;
        }

        class PoEntry
        {
            public uint origPos;
            public uint insPos;
            public string pos;
            public string japanese;
            public string english;
            public byte[] encoded;
            public bool found;
            public bool written;
            public int maxLen;
        }

        static void Main(string[] args)
        {
            string infolder = args[0]; // "orig\\D1_S00\\";
            string outFolder = args[1]; //"ins\\D1_S00\\";
            string tablefile = args[2];
            string widthsfile = args[3];
            int maxLen = Int32.Parse(args[4]);
            int maxTinyLen = Int32.Parse(args[5]);

            Dictionary<string, int> widths = new Dictionary<string, int>();
            string[] widthLines = File.ReadAllLines(widthsfile);

            //Get widths
            for (int i = 0; i < widthLines.Length; i++)
            {
                if (widthLines[i].Contains("const u8 dialogueLetterWidths"))
                {
                    for (int j = i + 1; j < widthLines.Length; j++)
                    {
                        if (widthLines[j].Contains("};"))
                            break;

                        if (widthLines[j].Trim().Length != 0)
                        {
                            string[] pieces = widthLines[j].Split(new string[] { "//" }, StringSplitOptions.RemoveEmptyEntries);
                            int width = Int32.Parse(pieces[0].Trim().Replace("0x", "").Replace(",", ""), System.Globalization.NumberStyles.HexNumber);
                            string letter = pieces[1][pieces[1].Length - 1].ToString();
                            if (letter == "")
                                letter = " ";

                            widths[letter] = width;
                        }
                    }
                    break;
                }
            }

            string[] table_entries = File.ReadAllLines(tablefile, Encoding.GetEncoding("SJIS"));
            Dictionary<string, string> table = new Dictionary<string, string>();
            foreach (string table_entry in table_entries)
            {
                if (table_entry.Length > 0)
                {
                    table[table_entry.Split('=')[0].ToUpper()] = table_entry.Split('=')[1];
                }
            }

            Dictionary<string, string> encodingTable = new Dictionary<string, string>();
            foreach (string table_entry in table_entries)
            {
                if (table_entry.Length > 0)
                {
                    encodingTable[table_entry.Split('=')[1]] = table_entry.Split('=')[0].ToUpper();
                    longestEntry = (longestEntry < (table_entry.Split('=')[1]).Length) ? (table_entry.Split('=')[1]).Length : longestEntry;
                }
            }
            
            string[] datFolders = Directory.GetDirectories(infolder);

            foreach(string datFolder in datFolders)
            {
                //orig\\D1_S00\\S000_DAT"

                //string poFile = datFolder.Replace("orig\\", "").Replace("\\", "_")
                string[] foldernames = datFolder.Split(new char[] { '\\' }, StringSplitOptions.RemoveEmptyEntries);
                string poFilename = "trans\\en\\" + foldernames[1] + "\\" + foldernames[1] + "_" + foldernames[2].Replace("_DAT", "") + ".po";

                List<PoEntry> poEntries = ParseTranslatedScriptFile(poFilename);

                string[] files = Directory.GetFiles(datFolder, "*.bin");
                foreach(string file in files)
                {
                    for (int i = 0; i < poEntries.Count; i++)
                    {
                        poEntries[i].found = false;
                    }

                    FileInfo fi = new FileInfo(file);


                    BinaryReader inBin = new BinaryReader(File.OpenRead(file));
                    inBin.BaseStream.Seek(4, SeekOrigin.Begin);
                    uint nextFilePos = inBin.ReadUInt32();
                    if (file.Contains("S008_DAT\\0013") || file.Contains("S012_DAT\\0006"))
                        nextFilePos = 0x4050;


                    long insTextPos = 0;
                    inBin.BaseStream.Seek(nextFilePos - 0x10, SeekOrigin.Begin);
                    while(true)
                    {
                        UInt64 isZero1 = inBin.ReadUInt64();
                        UInt64 isZero2 = inBin.ReadUInt64();
                        if (isZero1 == 0 && isZero2 == 0)
                        {
                            insTextPos = inBin.BaseStream.Position - 0x10;
                            inBin.BaseStream.Seek(-0x20, SeekOrigin.Current);
                        }
                        else
                            break;
                    }

                    insTextPos = ((insTextPos / 0x100) * 0x100) + 0x100;

                    int boopme = 0;


                    inBin.BaseStream.Seek(0, SeekOrigin.Begin);
                    uint evfhStart = inBin.ReadUInt32();
                    uint nextFileStart = inBin.ReadUInt32();
                    if (file.Contains("S008_DAT\\0013") || file.Contains("S012_DAT\\0006"))
                        nextFileStart = 0x4050;


                    inBin.BaseStream.Seek(evfhStart, SeekOrigin.Begin);

                    uint EVFH = inBin.ReadUInt32();
                    uint evidtblStart = inBin.ReadUInt32() + evfhStart;
                    uint evtofsStart = inBin.ReadUInt32() + evfhStart;
                    uint evtextStart = inBin.ReadUInt32() + evfhStart;


                    int defaultTextBoxWidth = maxLen;

                    while (true)
                    {
                        if (inBin.BaseStream.Position >= nextFileStart)
                            break;

                        if (inBin.BaseStream.Position >= 0x18C)
                        {
                            int boopme33 = 0;
                        }

                        byte aByte1 = inBin.ReadByte();
                        byte aByte2 = inBin.ReadByte();
                        byte aByte3 = inBin.ReadByte();
                        byte aByte4 = inBin.ReadByte();
                        byte aByte5 = inBin.ReadByte();
                        byte aByte6 = inBin.ReadByte();
                        if (aByte1 == 0x1B && aByte6 == 0x1A)
                        {
                            ushort dontCare = inBin.ReadUInt16();

                            uint origPos = (uint)inBin.BaseStream.Position;

                            List<byte> letters = new List<byte>();
                            while (inBin.BaseStream.Position < inBin.BaseStream.Length)
                            {
                                byte aLetterByte = inBin.ReadByte();
                                letters.Add(aLetterByte);
                                if (aLetterByte == 0)
                                {
                                    inBin.BaseStream.Seek(-1, SeekOrigin.Current);
                                    break;
                                }
                            }

                            string myLine = GetEncodedLine(letters.ToArray(), table).Replace("//", "").Replace("\n<$00>", "");

                            for (int i = 0; i < poEntries.Count; i++)
                            {
                                PoEntry poEntry = poEntries[i];
                                if (!String.IsNullOrEmpty(poEntry.english) && (poEntry.japanese == myLine || poEntry.japanese.Replace("＿", "　") == myLine) && !poEntry.found)
                                {
                                    poEntry.origPos = origPos;
                                    string english = Format(poEntry.english, defaultTextBoxWidth, widths);

                                    poEntry.encoded = Encode(english, encodingTable);
                                    poEntry.found = true;
                                    poEntry.written = false;
                                    poEntry.maxLen = defaultTextBoxWidth;
                                    poEntries[i] = poEntry;
                                    break;
                                }
                            }

                        }
                        else if ((aByte1 == 0x00 && aByte2 == 0x13 && aByte3 == 0x00 && aByte4 == 0x00) || (aByte1 == 0xFF && aByte2 == 0x13 && aByte3 == 0x00 && aByte4 == 0x00))
                        {
                            inBin.BaseStream.Seek(-2, SeekOrigin.Current);

                            uint origPos = (uint)inBin.BaseStream.Position;

                            inBin.BaseStream.Seek(-14, SeekOrigin.Current);
                            byte isWindowCommand = inBin.ReadByte();

                            if (isWindowCommand == 0x12)
                            {
                                inBin.BaseStream.Seek(6, SeekOrigin.Current);
                                ushort textBoxWidth = inBin.ReadUInt16();
                                if (textBoxWidth == 0x10)
                                {
                                    defaultTextBoxWidth = maxTinyLen;
                                }
                                else
                                {
                                    defaultTextBoxWidth = maxLen;
                                }

                            }

                            inBin.BaseStream.Seek(origPos, SeekOrigin.Begin);


                            List<byte> letters = new List<byte>();
                            while (inBin.BaseStream.Position < inBin.BaseStream.Length)
                            {
                                byte aLetterByte = inBin.ReadByte();
                                letters.Add(aLetterByte);
                                if (aLetterByte == 0)
                                {
                                    inBin.BaseStream.Seek(-1, SeekOrigin.Current);
                                    break;
                                }
                            }
                            string myLine = GetEncodedLine(letters.ToArray(), table).Replace("//", "").Replace("\n<$00>", "");

                            for (int i = 0; i < poEntries.Count; i++)
                            {
                                PoEntry poEntry = poEntries[i];
                                if (!String.IsNullOrEmpty(poEntry.english) && (poEntry.japanese == myLine || poEntry.japanese.Replace("＿", "　") == myLine) && !poEntry.found)
                                {
                                    poEntry.origPos = origPos;
                                    string english = Format(poEntry.english, defaultTextBoxWidth, widths);

                                    poEntry.encoded = Encode(english, encodingTable);
                                    poEntry.found = true;
                                    poEntry.maxLen = defaultTextBoxWidth;
                                    poEntries[i] = poEntry;
                                    break;
                                }
                            }
                        }
                        else
                        {
                            inBin.BaseStream.Seek(-5, SeekOrigin.Current);
                        }
                    }

                    // Dear past me.  Why didn't we just use the text positions that we store in the po file instead of searching for 
                    for (int i = 0; i < poEntries.Count; i++)
                    {
                        if (!poEntries[i].found)
                        {
                            int boopme3 = 0;
                        }
                    }

                    string outFilename = outFolder + "\\" + fi.Directory.Name + "\\" + fi.Name;
                    if (File.Exists(outFilename))
                        File.Delete(outFilename);

                    BinaryWriter newBin = new BinaryWriter(File.OpenWrite(outFilename));
                    inBin.BaseStream.Seek(0, SeekOrigin.Begin);
                    newBin.Write(inBin.ReadBytes((int)inBin.BaseStream.Length));

                    newBin.BaseStream.Seek(insTextPos, SeekOrigin.Begin);
                    for(int i = 0; i < poEntries.Count; i++)
                    {
                        PoEntry poEntry = poEntries[i];
                        if (poEntry.found)
                        {
                            if (((newBin.BaseStream.Position - evfhStart) % 0x100) == 0)
                            {
                                newBin.BaseStream.Seek(2, SeekOrigin.Current);
                            }


                            int insPosStart = (int)newBin.BaseStream.Position;
                            int insPosEnd = (int)newBin.BaseStream.Position + poEntry.encoded.Length;

                            poEntry.insPos = (uint)newBin.BaseStream.Position - evfhStart;
                            poEntries[i] = poEntry;

                            newBin.Write(poEntry.encoded);
                            newBin.Write((byte)0);
                        }

                        if (newBin.BaseStream.Position >= nextFilePos)
                        {
                            int breakMe = 0;
                        }                            
                    }

                    for (int i = 0; i < poEntries.Count; i++)
                    {
                        PoEntry poEntry = poEntries[i];
                        if (poEntry.found)
                        {
                            newBin.BaseStream.Seek(poEntry.origPos, SeekOrigin.Begin);
                           // newBin.Write((byte)0x80);
                            newBin.Write((ushort)poEntry.insPos);
                        }
                    }

                    newBin.Close();
                }
            }
        }
    }
}

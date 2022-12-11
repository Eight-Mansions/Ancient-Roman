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

        static byte[] EncodeToHex(string text, Dictionary<string, string> table)
        {
            int longestEntry = table.Keys.OrderByDescending(x => x.ToString().Length).First().Length / 2;

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

            bool foundId = false;
            string pos = "";
            string japanese = "";
            string english = "";
            string[] translatedLines = File.ReadAllLines(TranslatedScriptFile);
            for (int i = 0; i < translatedLines.Length; i++)
            {
                string translatedLine = translatedLines[i];
                if (translatedLine.StartsWith("#:"))
                {
                    pos = translatedLine.Substring(2).Trim();
                    foundId = true;
                }
                else if (foundId && translatedLine.StartsWith("msgid"))
                {
                    japanese = "";
                    for (int j = i; j < translatedLines.Length; j++)
                    {
                        string line = regex.Match(translatedLines[j]).Value;
                        japanese += line.Substring(1, line.Length - 2);

                        if (j + 1 < translatedLines.Length && !translatedLines[j + 1].StartsWith("\""))
                        {
                            i = j;
                            break;
                        }
                    }
                }
                else if (foundId && translatedLine.StartsWith("msgstr"))
                {
                    english = "";
                    for (int j = i; j < translatedLines.Length; j++)
                    {
                        string line = regex.Match(translatedLines[j]).Value;
                        english += line.Substring(1, line.Length - 2);

                        if (j + 1 < translatedLines.Length && !translatedLines[j + 1].StartsWith("\""))
                        {
                            i = j;
                            break;
                        }
                    }
                }

                if (!String.IsNullOrEmpty(pos) && !String.IsNullOrEmpty(japanese) && !String.IsNullOrEmpty(english))
                {
                    poEntries.Add(new PoEntry()
                    {
                        pos = pos,
                        japanese = japanese,
                        english = english.Replace("<$00>", "")
                    });

                    pos = "";
                    japanese = "";
                    english = "";
                }

            }

            return poEntries;
        }

        class PoEntry
        {
            public string pos;
            public string japanese;
            public string english;
        }

        static void Main(string[] args)
        {
            string infolder = args[0]; // "orig\\D1_S00\\";
            string outFolder = args[1]; //"ins\\D1_S00\\";
            string tablefile = args[2];

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
                    FileInfo fi = new FileInfo(file);


                    BinaryReader inBin = new BinaryReader(File.OpenRead(file));

                    MemoryStream outBin = new MemoryStream();
                    uint evfhStart = inBin.ReadUInt32();
                    uint nextFileStart = inBin.ReadUInt32();

                    inBin.BaseStream.Seek(evfhStart, SeekOrigin.Begin);

                    uint EVFH = inBin.ReadUInt32();
                    uint evidtblStart = inBin.ReadUInt32() + evfhStart;
                    uint evtofsStart = inBin.ReadUInt32() + evfhStart;
                    uint evtextStart = inBin.ReadUInt32() + evfhStart;
                    uint evtofsNumEntries = inBin.ReadUInt32();

                    List<uint> evtofsEntries = new List<uint>();

                    inBin.BaseStream.Seek(evtofsStart, SeekOrigin.Begin);
                    for (int i = 0; i < evtofsNumEntries; i++)
                    {
                        evtofsEntries.Add(inBin.ReadUInt32() + evtextStart);
                    }
                    List<uint> newEvtofsEntries = new List<uint>(evtofsEntries);

                    inBin.BaseStream.Seek(0, SeekOrigin.Begin);
                    outBin.Write(inBin.ReadBytes((int)evtextStart), 0, (int)evtextStart);

                    while(true)
                    {
                        if (inBin.BaseStream.Position >= nextFileStart)
                            break;

                        if (inBin.BaseStream.Position == (0x1F21 + evtextStart))
                        {
                            int boopme = 0;
                        }
                        if (evtofsEntries.Contains((uint)inBin.BaseStream.Position))
                        {
                            newEvtofsEntries[evtofsEntries.IndexOf((uint)inBin.BaseStream.Position)] = (uint)outBin.Position;
                        }

                        byte aByte1 = inBin.ReadByte();
                        byte aByte2 = inBin.ReadByte();
                        byte aByte3 = inBin.ReadByte();
                        byte aByte4 = inBin.ReadByte();
                        if (aByte1 == 0x00 && aByte2 == 0x13 && aByte3 == 0x00 && aByte4 == 0x00)
                        {
                            outBin.WriteByte(aByte1);
                            outBin.WriteByte(aByte2);
                            outBin.WriteByte(aByte3);
                            outBin.WriteByte(aByte4);

                            List<byte> letters = new List<byte>();
                            while (inBin.BaseStream.Position < inBin.BaseStream.Length)
                            {
                                byte aLetterByte = inBin.ReadByte();
                                letters.Add(aLetterByte);
                                if (aLetterByte == 0)
                                {
                                    if (inBin.BaseStream.Position == 0x18E5)
                                    {
                                        int boopme = 0;
                                    }

                                    inBin.BaseStream.Seek(-1, SeekOrigin.Current);
                                    break;
                                }
                            }
                            string myLine = GetEncodedLine(letters.ToArray(), table).Replace("//", "").Replace("\n<$00>", "");
                            PoEntry poEntry = poEntries.Where(p => (p.japanese == myLine || p.japanese.Replace("＿", "　") == myLine) && !String.IsNullOrEmpty(p.english)).FirstOrDefault();
                            if (poEntry != null)
                            {
                                byte[] encoded = EncodeToHex(poEntry.english.ToUpper(), encodingTable);
                                outBin.Write(encoded, 0, encoded.Length);
                            }
                            else
                            {
                                byte[] encoded = EncodeToHex(myLine, encodingTable);
                                outBin.Write(encoded, 0, encoded.Length);
                            }

                        }
                        else
                        {
                            outBin.WriteByte(aByte1);
                            inBin.BaseStream.Seek(-3, SeekOrigin.Current);
                        }
                    }

                    string outFilename = outFolder + "\\" + fi.Directory.Name + "\\" + fi.Name;
                    if (File.Exists(outFilename))
                        File.Delete(outFilename);

                    BinaryWriter newBin = new BinaryWriter(File.OpenWrite(outFilename));
                    inBin.BaseStream.Seek(0, SeekOrigin.Begin);
                    newBin.Write(inBin.ReadBytes((int)inBin.BaseStream.Length));

                    
                    newBin.Seek(0, SeekOrigin.Begin);

                    int outLen = (outBin.Position > nextFileStart) ? (int)nextFileStart : (int)outBin.Position;
                    byte[] scriptBytes = new byte[outLen];
                    Array.Copy(outBin.ToArray(), scriptBytes, outLen);
                    newBin.Write(scriptBytes);


                    newBin.BaseStream.Seek(evtofsStart, SeekOrigin.Begin);
                    for (int i = 0; i < evtofsNumEntries; i++)
                    {
                        newBin.Write((uint)(newEvtofsEntries[i] - evtextStart));
                    }

                    newBin.Close();
                }
            }
        }
    }
}

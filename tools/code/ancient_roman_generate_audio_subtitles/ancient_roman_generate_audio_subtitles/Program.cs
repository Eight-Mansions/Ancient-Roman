using SubtitlesParser.Classes;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;

namespace kowloons_gate_generate_audio_subtitles
{
    class Program
    {
        static int GetWidth(string line, Dictionary<string, int> widths)
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

        static string Format(string block, int max_len, Dictionary<string, int> widths)
        {
            //block = block.Replace("\\n", "\r");
            string[] lines = block.Split(new string[] { "\\n" }, StringSplitOptions.None);


            string formattedBlock = "";
            string formattedLine = "";

            int curWidth = 0;
            //foreach (string line in lines)
            for (int i = 0; i < lines.Length; i++)
            {
                string line = lines[i];
                if (line.IndexOf("//") != 0)
                {
                    int lineIdx = 0;
                    line = line.Replace("\\n", "\r");
                    while (true)
                    {
                        if (lineIdx == line.Length)
                            break;

                        if (line[lineIdx] == '<' && lineIdx + 1 < line.Length && line[lineIdx + 1] == '$')
                        {
                            while (true)
                            {
                                formattedLine += line[lineIdx++];
                                if (line[lineIdx - 1] == '>')
                                {
                                    break;
                                }
                            }
                        }
                        else if (line[lineIdx] == '\r')
                        {
                            formattedBlock += formattedLine + "\n";
                            formattedLine = "";
                            curWidth = 0;
                            lineIdx++;
                        }
                        else
                        {
                            formattedLine += line[lineIdx++];
                        }

                        if (GetWidth(formattedLine, widths) > max_len)
                        {
                            int formattedLineLength = formattedLine.Length - 1;
                            while (true)
                            {
                                formattedLineLength--;
                                if (formattedLineLength == 0)
                                {
                                    formattedBlock += formattedLine + "\n";
                                    formattedLine = ""; //It's too big to fit ah well....
                                    curWidth = 0;
                                    break;
                                }

                                if ((curWidth + GetWidth(formattedLine.Substring(0, formattedLineLength), widths)) < max_len && formattedLine[formattedLineLength] == ' ')
                                {
                                    formattedBlock += formattedLine.Substring(0, formattedLineLength) + "\n";
                                    formattedLine = formattedLine.Substring(formattedLineLength + 1);
                                    curWidth = 0;
                                    break;
                                }
                            }
                        }
                    }

                    curWidth += GetWidth(formattedLine, widths);
                    formattedBlock += formattedLine + "\n";
                    formattedLine = "";
                }
                else
                {
                    formattedBlock += line + "\n";
                }
            }

            return formattedBlock.Trim();
        }

        static int[] GetEncoding(string line, string mapping)
        {
            List<int> mappings = new List<int>();
            for (int i = 0; i < line.Length; i++)
            {
                mappings.Add(mapping.IndexOf(line[i]));
            }
            return mappings.ToArray();
        }

        static int sdbmHash(string audioname)
        {
            int hash = 0;
            int i = 0;

            for (; audioname[i] != 0; i++)
            {
                hash = audioname[i] + (hash << 6) + (hash << 16) - hash;
            }
            return hash;
        }

        class SubLine
        {
            public string line;
            public int startTime;
            public int endTime;
        }

        static void Main(string[] args)
        {
            string subsDir = args[0]; //"movie_subs";
            string widthsfile = args[1];

            string outputfile = "code\\ancient-roman\\code\\generated_audio.cpp";

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

            //var something = new Opportunity.AssLoader.
            if (File.Exists(outputfile))
                File.Delete(outputfile);

            StreamWriter generated = new StreamWriter(outputfile, false);
            generated.WriteLine("#include \"generated.h\"");
            generated.WriteLine();

            int partIdx = 0;
            int subIdx = 0;
            int defaultX = -140;
            int defaultY = -76;
            List<string> subs = new List<string>();

            string[] movieAssNames = Directory.GetFiles(subsDir, "*.ass", SearchOption.AllDirectories);
            movieAssNames = movieAssNames.OrderBy(ass => new FileInfo(ass).Name).ToArray();
            foreach (string assname in movieAssNames)
            {
                //string assname = "EV1A_1M07.ass";
                var parser = new SubtitlesParser.Classes.Parsers.SubParser();
                var lines = parser.ParseStream(File.OpenRead(assname));

                FileInfo assFileInfo = new FileInfo(assname);
                string assDir = assFileInfo.Directory.Name;
                string assName = assFileInfo.Name;
                if (assName == "Y[0.1].ass")
                    assName = assName.Replace("Y", "Y.");

                int indexOfBracket = assName.IndexOf("[");
                int indexOfOtherBracket = assName.IndexOf("]");

                string strName = "\\XAEFF\\" + assName.Substring(0, indexOfBracket) + ";1";
                string idx = assName.Substring(indexOfBracket + 1, indexOfOtherBracket - (indexOfBracket + 1));


                int hash = sdbmHash(strName + '\0');

                List<SubLine> subLines = new List<SubLine>();
                for (int i = 0; i < lines.Count; i++)
                {
                    SubtitleItem line = lines[i];
                    foreach (string plainLine in line.PlaintextLines)
                    {
                        if (plainLine.Length > 0 && plainLine[0] < 0x80 && plainLine[0] >= 0x20)
                        {
                            string[] formatted = new[] { plainLine }; //Format(plainLine, 304, null).Split(new char[] { '\n' });
                            foreach (string format in formatted)
                            {
                                subLines.Add(new SubLine()
                                {
                                    line = format.Replace("—", "-"),
                                    startTime = line.StartTime,
                                    endTime = line.EndTime
                                }); ;
                            }
                        }
                    }

                }

                List<string> partdata = new List<string>();
                int timing = 1;
                //foreach (string engLine in subLines)
                int y = defaultY;
                for (int i = 0; i < subLines.Count; i++)
                {
                    SubLine subLine = subLines[i];
                    string engLine = subLine.line.Replace("“", "\"").Replace("”", "\"").Replace("’", "'").Replace("{\\i1}", "").Replace("{\\i0}", "");
                    int startFrame = (int)(((float)15 / (float)1000) * subLine.startTime); // 15 frames per second
                    int endFrame = (int)(((float)15 / (float)1000) * subLine.endTime);

                    if (!String.IsNullOrEmpty(engLine))
                    {
                        int textWidth = GetWidth(engLine, widths);
                        int totalPadding = (320 - textWidth) / 2;
                        int x = defaultX + totalPadding;
                        if (strName.Contains("SHOP.XA"))
                        {
                            x = -0x2A;
                            y = 0x58;
                        }


                        //if (i != 0 && (subLines[i - 1].startTime <= subLines[i].startTime && subLines[i].startTime < subLines[i - 1].endTime))
                        //{
                        //    y += 16;
                        //}
                        //else
                        //{
                        //    y = defaultY;
                        //}

                        byte[] encoding = Encoding.ASCII.GetBytes(engLine); //GetEncoding(engLine, mapping);

                        generated.WriteLine("//" + strName + " | "  + idx  + " | " + engLine);
                        generated.WriteLine(String.Format("const u8 partdata_{0}[] = {{{1}}};", partIdx, String.Join(", ", encoding)));
                        generated.WriteLine("");




                        partdata.Add(String.Format("{{(const char*)partdata_{0}, {1}, {2}, {3}, {4}, {5}}},", partIdx, encoding.Length, startFrame, endFrame, x, y));

                        timing += 14;
                        partIdx++;
                    }
                }

                generated.WriteLine(String.Format("AudioSubtitlePart sub{0}_parts[] = {{", subIdx));
                foreach (string parts in partdata)
                {
                    generated.WriteLine("\t" + parts);
                }
                generated.WriteLine("};");
                generated.WriteLine("");

                subs.Add(String.Format("{{{0}, {1}, {2}, sub{3}_parts}},", hash, idx, partdata.Count, subIdx));

                subIdx++;
            }

            generated.WriteLine("const u32 audioSubtitlesCount = {0};", subIdx);
            generated.WriteLine("AudioSubtitle audioSubtitles[] = {");

            foreach (string sub in subs)
            {
                generated.WriteLine("\t" + sub);
            }

            generated.WriteLine("};");

            generated.Close();
        }
    }
}

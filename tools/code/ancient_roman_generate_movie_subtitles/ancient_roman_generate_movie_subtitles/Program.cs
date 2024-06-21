using SubtitlesParser.Classes;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;

namespace ancient_roman_generate_movie_subtitles
{
    class Program
    {
        static int GetWidth(string line)
        {
            int cur_len = 0;
            for (int i = 0; i < line.Length; i++)
            {
                cur_len += 0x08; // Hard coded for now

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

                        if (GetWidth(formattedLine) > max_len)
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

                                if ((curWidth + GetWidth(formattedLine.Substring(0, formattedLineLength))) < max_len && formattedLine[formattedLineLength] == ' ')
                                {
                                    formattedBlock += formattedLine.Substring(0, formattedLineLength) + "\n";
                                    formattedLine = formattedLine.Substring(formattedLineLength + 1);
                                    curWidth = 0;
                                    break;
                                }
                            }
                        }
                    }

                    curWidth += GetWidth(formattedLine);
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
            string mappingfilename = args[1];  //"movie_mapping.txt";
            string mapping = File.ReadAllText(mappingfilename).Replace("\r", "").Replace("\n", "");

            //var something = new Opportunity.AssLoader.
            if (File.Exists("code\\ancient-roman\\code\\generated_movie.cpp"))
                File.Delete("code\\ancient-roman\\code\\generated_movie.cpp");

            StreamWriter generated = new StreamWriter("code\\ancient-roman\\code\\generated_movie.cpp", false);
            generated.WriteLine("#include \"generated.h\"");
            generated.WriteLine();

            int partIdx = 0;
            int subIdx = 0;
            int defaultX = 0;
            int defaultY = 190;
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

                int indexOfBracket = assName.IndexOf("[") + 1;

                string strName = "\\" + assDir + "\\" + assName.Substring(0, indexOfBracket - 1) + ";1";

                int hash = sdbmHash(strName + '\0');

                List<SubLine> subLines = new List<SubLine>();
                for (int i = 0; i < lines.Count; i++)
                {
                    SubtitleItem line = lines[i];
                    foreach (string plainLine in line.PlaintextLines)
                    {
                        string[] formatted = Format(plainLine, 304, null).Split(new char[] { '\n' });
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
                        int textWidth = GetWidth(engLine);
                        while ((textWidth / 2) % 8 != 0)
                            textWidth++;

                        int totalPadding = ((320 >> 1) - (textWidth >> 1));
                        totalPadding = (int)Math.Ceiling((decimal)(totalPadding / 8)) * 8;
                        int x = defaultX + totalPadding;


                        if (i != 0 && (subLines[i - 1].startTime <= subLines[i].startTime && subLines[i].startTime < subLines[i - 1].endTime))
                        {
                            y += 16;
                        }
                        else
                        {
                            y = defaultY;
                        }

                        int[] encoding = GetEncoding(engLine, mapping);

                        generated.WriteLine("//" + strName + " | " + engLine);
                        generated.WriteLine(String.Format("const u8 partdata_{0}[] = {{{1}}};", partIdx, String.Join(", ", encoding)));
                        generated.WriteLine("");




                        partdata.Add(String.Format("{{(const char*)partdata_{0}, {1}, {2}, {3}, {4}, {5}, {6}, {7}, {8}}},", partIdx, encoding.Length, 255, startFrame, endFrame, x, y, x, y));

                        timing += 14;
                        partIdx++;
                    }
                }

                generated.WriteLine(String.Format("MovieSubtitlePart sub{0}_parts[] = {{", subIdx));
                foreach (string parts in partdata)
                {
                    generated.WriteLine("\t" + parts);
                }
                generated.WriteLine("};");
                generated.WriteLine("");

                subs.Add(String.Format("{{{0}, {1}, sub{2}_parts}},", hash, partdata.Count, subIdx));

                subIdx++;
            }

            generated.WriteLine("const u32 movieSubtitlesCount = {0};", subIdx);
            generated.WriteLine("MovieSubtitle movieSubtitles[] = {");

            foreach (string sub in subs)
            {
                generated.WriteLine("\t" + sub);
            }

            generated.WriteLine("};");

            generated.Close();
        }
    }
}

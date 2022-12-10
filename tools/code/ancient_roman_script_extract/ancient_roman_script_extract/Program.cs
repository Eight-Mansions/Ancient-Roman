using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ancient_roman_script_extract
{
    class Program
    {
        static uint SwapEndian(uint number)
        {
            return (number << 24) | (number & 0x0000FF00) << 8 | (number & 0x00FF0000) >> 8 | (number >> 24);
        }

        static ushort SwapEndian(ushort number)
        {
            return (ushort)(((number & 0x00FF) << 8) | ((number & 0xFF00) >> 8));
        }

        static void PrintPrettyHex(StreamWriter txt, byte hex)
        {
            txt.Write("<$" + (hex & 0xFF).ToString("X2") + ">");
        }

        static void PrintPrettyHex(StreamWriter txt, ushort hex)
        {
            txt.Write("<$" + ((hex & 0xFF00) >> 8).ToString("X2") + ">");
            txt.Write("<$" + ((hex & 0xFF)).ToString("X2") + ">");
        }

        static string PrintPrettyHex(ushort hex)
        {
            string pretty = "<$" + ((hex & 0xFF)).ToString("X2") + ">";
            pretty += "<$" + ((hex & 0xFF00) >> 8).ToString("X2") + ">";
            return pretty;
        }

        static string PrintPrettyHex(byte hex)
        {
            string pretty = "<$" + hex.ToString("X2") + ">";
            return pretty;
        }


        class Line
        {
            public string filename;
            public string line;
            public uint pos;
        }

        class Ptr
        {
            public uint orig_ptr;
            public uint ptr;
            public uint unk1;
            public uint offset;
            public ushort id;
            public uint script_end;
            public List<int> pos = new List<int>();
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

        static string GetPrettyLine(string myLine, string newLine)
        {
            string prettyLine = "";
            foreach (string portion in myLine.Split(new string[] { newLine }, StringSplitOptions.RemoveEmptyEntries))
            {
                if (portion[0] != '<')
                {
                    prettyLine += "//";
                }

                for (int i = 0; i < portion.Length; i++)
                {
                    if (portion[i] == '<')
                    {
                        if (i - 1 > 0 && portion[i - 1] != '>')
                        {
                            prettyLine += "\n//";
                        }
                    }

                    prettyLine += portion[i];

                    if (portion[i] == '>')
                    {
                        if (i + 1 < portion.Length && portion[i + 1] != '<')
                        {
                            prettyLine += "\n//";
                        }
                    }
                }


                prettyLine += newLine + "\n";
            }

            prettyLine = prettyLine.Trim();
            if (prettyLine.Length > 0)
            {
                prettyLine = prettyLine.Substring(0, prettyLine.Length - 3);
            }

            return prettyLine;
        }

        static List<Ptr> FindPointers(BinaryReader block, uint offset, uint start, uint end, int mask, uint script_block_start, uint script_block_end)
        {
            List<Ptr> ptrs = new List<Ptr>();

            block.BaseStream.Seek(start, SeekOrigin.Begin);
            while (block.BaseStream.Position + 4 < end)
            {
                uint isText = block.ReadUInt32();
                if (isText == 0x00001300)
                {
                    Ptr newPtr = new Ptr();
                    newPtr.ptr = (uint)block.BaseStream.Position;
                    ptrs.Add(newPtr);
                }
                else
                {
                    block.BaseStream.Seek(-3, SeekOrigin.Current);
                }
            }

            return ptrs;
        }

        static string GetPOLine(string myLine)
        {
            string msgid = "msgid \"\"\n";
            foreach (string line in myLine.Split(new char[] { '\n' }))
            {
                if (line.Length > 0)
                {
                    if (line.IndexOf("//") == 0)
                    {
                        msgid += "\"" + line.Substring(2).Replace("\"", "\\\"").Replace("'", "\\'") + "\"" + "\n";
                    }
                    else
                    {
                        msgid += "\"" + line.Replace("\"", "\\\"").Replace("'", "\\'") + "\"" + "\n";
                    }
                }
            }
            msgid = msgid.Trim() + "\nmsgstr \"\"";
            return msgid;
        }


        static void WriteStrings(List<Ptr> ptrs, StreamWriter script_txt, StreamWriter po_txt, BinaryReader script_bin, Dictionary<string, string> table, string curfilename)
        {
            ptrs = ptrs.OrderBy(x => x.ptr).ToList();

            bool has_text = false;

            List<string> found = new List<string>();

            script_txt.Write("#VAR(Table, TABLE)\n");
            script_txt.Write("#ADDTBL(\"sjis.tbl\", Table)\n");
            script_txt.Write("#ACTIVETBL(Table)\n");
            //script_txt.Write("#STRINGALIGN(2)\n");
            script_txt.Write("#VAR(PTR, CUSTOMPOINTER)\n");
            script_txt.Write("#CREATEPTR(PTR, \"LINEAR\", -" + (ptrs[0].offset) + ", 32)\n");
            script_txt.Write("#JMP($" + ptrs.OrderBy(p => p.ptr).First().ptr.ToString("X8") + ")\n\n");

            for (int i = 0; i < ptrs.Count; i++)
            {
                script_bin.BaseStream.Seek(ptrs[i].ptr, SeekOrigin.Begin);

                List<byte> letters = new List<byte>();
                while (script_bin.BaseStream.Position < script_bin.BaseStream.Length)
                {
                    byte aByte = script_bin.ReadByte();
                    letters.Add(aByte);
                    if (aByte == 0)
                    {
                        break;
                    }
                }
                script_txt.Write("//P: " + ptrs[i].ptr.ToString("X8") + "\n");


                string myLine = GetEncodedLine(letters.ToArray(), table);
                myLine = myLine.Replace("\\r", "\n//");

                script_txt.Write(myLine);
                script_txt.Write("\n\n");

                String poLine = GetPOLine(myLine);
                po_txt.Write("#: " + ptrs[i].ptr.ToString("X8") + "\n");
                po_txt.Write(poLine);
                po_txt.Write("\n\n");

            }
        }

        //static List<string> lines = new List<string>();
        static List<Line> lines = new List<Line>();

        static void Main(string[] args)
        {
            if (File.Exists("1_insert.bat"))
                File.Delete("1_insert.bat");


            StreamWriter batchme = new StreamWriter("1_insert.bat");
            batchme.WriteLine("del error.txt");
            batchme.WriteLine("del /q /s ins\\*");
            batchme.WriteLine("xcopy /e orig\\* ins");
            batchme.WriteLine();

            string[] table_entries = File.ReadAllLines("sjis.tbl", Encoding.GetEncoding("SJIS"));
            Dictionary<string, string> table = new Dictionary<string, string>();
            foreach (string table_entry in table_entries)
            {
                if (table_entry.Length > 0)
                {
                    table[table_entry.Split('=')[0].ToUpper()] = table_entry.Split('=')[1];
                }
            }

            string blockID = "EVTEXT";

            int ptr_mask = 0;

            string[] files = Directory.GetFiles("scenes", "*", SearchOption.AllDirectories);
            foreach (string file in files)
            {
                FileInfo fi = new FileInfo(file);
                string dir = fi.Directory.Name;
                string path = fi.Directory.FullName;
                string filename = fi.Name;

                uint script_block_start = 0;
                uint script_block_end = 0;

                uint ptr_block_start = 0;
                uint ptr_block_end = 0;

                uint offset = 0;

                if (filename == "SLAVEIN2.EVT")
                {
                    int test = 0;
                }

                BinaryReader script_bin = new BinaryReader(File.OpenRead(file));
                List<Ptr> ptrs = new List<Ptr>();
                while (script_bin.BaseStream.Position + blockID.Length < script_bin.BaseStream.Length)
                {
                    string magicid = Encoding.GetEncoding("SJIS").GetString(script_bin.ReadBytes(blockID.Length));
                    //if (magicid == "EVTEXT")
                    {
                        script_block_start = (uint)script_bin.BaseStream.Position;
                        ptr_block_start = (uint)script_bin.BaseStream.Position;
                        while (script_bin.BaseStream.Position + 4 < script_bin.BaseStream.Length)
                        {
                            UInt64 isZero = script_bin.ReadUInt32();
                            if (isZero == 0)
                            {
                                script_block_end = (uint)script_bin.BaseStream.Position;
                                ptr_block_end = (uint)script_bin.BaseStream.Position;

                                ptrs.AddRange(FindPointers(script_bin, offset, ptr_block_start, ptr_block_end, ptr_mask, script_block_start, script_block_end));

                                script_bin.BaseStream.Seek(script_block_end, SeekOrigin.Begin);
                                break;
                            }
                            script_bin.BaseStream.Seek(-3, SeekOrigin.Current);
                        }
                        //break;
                    }
                    script_bin.BaseStream.Seek(-5, SeekOrigin.Current);
                }

                if (script_block_end == 0)
                {
                    script_block_end = (uint)script_bin.BaseStream.Length;
                    ptr_block_end = (uint)script_bin.BaseStream.Length;

                    ptrs.AddRange(FindPointers(script_bin, offset, ptr_block_start, ptr_block_end, ptr_mask, script_block_start, script_block_end));
                }

                if (ptrs.Count > 0)
                {
                    batchme.WriteLine("echo ins\\" + file.Replace("orig\\", "") + " >> error.txt");
                    batchme.WriteLine("tools\\atlas ins\\" + file.Replace("orig\\", "") + " trans\\" + file.Replace("orig\\", "") + ".txt >> error.txt");

                    if (File.Exists(path + "\\" + dir + "_" + filename + ".txt"))
                    {
                        File.Delete(path + "\\" + dir + "_" + filename + ".txt");
                        File.Delete(path + "\\" + dir + "_" + filename.Replace(".DAT", "") + ".po");
                    }

                    StreamWriter script_txt = new StreamWriter(path + "\\" + dir + "_" + filename + ".txt", false, Encoding.GetEncoding("SJIS"));
                    StreamWriter po_txt = new StreamWriter(path + "\\" + dir + "_" + filename.Replace(".DAT", "") + ".po", false, Encoding.UTF8);

                    WriteStrings(ptrs, script_txt, po_txt, script_bin, table, file);

                    script_txt.Close();
                    po_txt.Close();
                }

                script_bin.Close();

            }

            batchme.Close();

            //if (File.Exists("fox_junction-script-jap.txt"))
            //    File.Delete("fox_junction-script-jap.txt");
            //StreamWriter theOne = new StreamWriter("fox_junction-script-jap.txt", false, Encoding.GetEncoding("SJIS"));
            //foreach (Line line in lines)
            //{
            //    theOne.WriteLine("//F:" + line.filename);
            //    theOne.WriteLine("//P:" + line.pos.ToString("X8"));
            //    theOne.WriteLine(line.line);
            //    theOne.WriteLine();
            //}
            //theOne.Close();

        }
    }
}
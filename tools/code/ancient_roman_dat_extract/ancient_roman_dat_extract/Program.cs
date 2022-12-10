using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ancient_roman_dat_extract
{
    class Program
    {
        static void Main(string[] args)
        {
            string indir = "S00";
            string[] files = Directory.GetFiles(indir);
            foreach(string file in files)
            {
                string outfile = file.Replace(".DAT", "_DAT");
                if (!Directory.Exists(outfile))
                    Directory.CreateDirectory(outfile);

                BinaryReader dat = new BinaryReader(File.OpenRead(file));

                long numOfFiles = dat.BaseStream.Length / 0x44800;
                for(int i = 0; i < numOfFiles; i++)
                {
                    dat.BaseStream.Seek(i * 0x44800, SeekOrigin.Begin);
                    File.WriteAllBytes(outfile + "\\" + i.ToString("D4") + ".bin", dat.ReadBytes(0x44800));
                }

                dat.Close();
            }
        }
    }
}

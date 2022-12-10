using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ancient_roman_dat_insert
{
    class Program
    {
        static void Main(string[] args)
        {
            string indir = args[0]; //"ins";
            string[] folders = Directory.GetDirectories(indir, "*_DAT", SearchOption.AllDirectories);
            foreach(string folder in folders)
            {
                DirectoryInfo di = new DirectoryInfo(folder);
                string outFilename = indir + "\\" + di.Parent + "\\" + di.Name.Replace("_DAT", ".DAT");

                if (File.Exists(outFilename))
                    File.Delete(outFilename);

                BinaryWriter outDat = new BinaryWriter(File.OpenWrite(outFilename));

                foreach(string file in Directory.GetFiles(folder))
                {
                    outDat.Write(File.ReadAllBytes(file));
                }

                outDat.Close();
            }
        }
    }
}

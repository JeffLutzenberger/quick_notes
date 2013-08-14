import os
import sys
import getopt
from subprocess import call
#from BeautifulSoup import BeautifulSoup
from markdown import markdown
"""
Script takes a folder of quick_notes, loops over all files and converts
to html via markdown parser. The result is saved as an html file and a
link to the html is echoed to the command line
"""


def read_notes(dir_name):

    out_file_path = dir_name + 'notes.html'
    # open the file and overwrite if it exists
    #if os.path.exists(out_file_path):
    #    print("file found")
    #    out_file = file(out_file_path, "r+")
    #else:
    #    print("creating file")
    out_file = file(out_file_path, "w")
    #out_file = open(out_file_path, 'r+')
    out_file.write('<head><style>')
    out_file.write('body {font-family:arial}')
    out_file.write('</style></head>')

    for root, dirs, files in os.walk(dir_name):
        #newer to older
        files.reverse()
        #last file is the current file (does not have date appended) so we
        #move that one to the top
        files.insert(0, files.pop())
        for f in files:
            fullpath = os.path.join(root, f)
            print fullpath
            f = open(fullpath, 'r')
            out_file.write(markdown(f.read()))
            out_file.write('<hr>')

    # if we're overwriting truncate the file so that we don't end up with
    # extra old text
    out_file.truncate()
    out_file.close()
    print out_file_path
    #text = ''.join(BeautifulSoup(html).findAll(text=True))
    call(["open", out_file_path])


def main(argv):
    inputfolder = ''

    try:
        opts, args = getopt.getopt(argv, "i:o:", ["ifolder="])
    except getopt.GetoptError:
        print 'quick_html.py -i <inputfolder>'
        sys.exit(2)

    for opt, arg in opts:
        if opt == '-h':
            print 'quick_html.py -i <inputfolder>'
            sys.exit()
        elif opt in ("-i", "--ifolder"):
            inputfolder = arg

    print 'Input folder is ', inputfolder
    read_notes(inputfolder)


if __name__ == "__main__":
    main(sys.argv[1:])

import os,glob,re
from datetime import datetime
import shutil

def publishFile(file):
    print("Parsing file [",file+"]")
    with open(file, 'r') as article:
        lines = article.read().splitlines()
        for line in lines:
            matched=re.match('date:(.*)',line)
            if(bool(matched)):
                datetime_object = datetime.fromisoformat(line[6:])
                # Only publish if the date specified in the file is older than now()
                if(datetime_object < datetime.now()):
                    basename=os.path.basename(file)
                    dest=POSTS_FOLDER+"/"+datetime_object.strftime("%Y-%m-%d")+"-"+basename
                    print("Copying draft [",file,"] to [",dest,"]")
                    shutil.copy(file,dest)   
                    os.remove(file)
                    print("Draft published")
                else:
                    print("This file [",file,":(",datetime_object,")] is newer than now")

def main():
    for file in glob.glob(DRAFTS_FOLDER+"/*.md", recursive = False):
        print("------------------------------------------------")
        print("Handling [",file,"]")
        publishFile(file)
        print("------------------------------------------------")

if __name__ == "__main__":
    DRAFTS_FOLDER = os.getenv('DRAFTS_FOLDER', '_drafts')
    POSTS_FOLDER = os.getenv('POSTS_FOLDER', '_posts')
    main()

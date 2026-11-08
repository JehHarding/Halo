# Publishes whichever blog in publish_manifest.json is dated today (does nothing if none).
import json,subprocess,datetime,os
d=os.path.dirname(os.path.abspath(__file__))
today=datetime.date.today().isoformat()
for date,slug,title,exc,tag,cat,read,cover in json.load(open(d+'/publish_manifest.json')):
    if date==today:
        staged=os.path.abspath(d+'/../../posts/thursday-blogs/'+slug+'.html')
        r=subprocess.run(['python3',d+'/publish_blog.py',slug,title,exc,tag,cat,read,'images/blog-covers/'+cover+'.webp','--staged',staged])
        print('EXIT',r.returncode,'https://myhaloapp.co.uk/blog/'+slug+'.html')
        break
else: print('Nothing scheduled for',today)

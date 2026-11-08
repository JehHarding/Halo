#!/usr/bin/env python3
"""Publish one finished Halo blog post: adds the page, its card on blog.html and its sitemap line,
commits just those files, pushes, and checks the live page returns 200.
Always builds from origin/main so other unpublished cards never leak.
Usage: publish_blog.py SLUG "Title" "Excerpt" "Tag label" CAT "N min read" COVER.webp [--staged PATH] [--dry-run]
  CAT is one of: health medications travel behind"""
import sys, os, re, subprocess, shutil, time, urllib.request
from PIL import Image
REPO='/Users/mrsharding/Documents/Code/Halo Website'
def run(*a,check=True):
    r=subprocess.run(a,cwd=REPO,capture_output=True,text=True)
    if check and r.returncode: sys.exit('FAILED: '+' '.join(a)+'\n'+r.stderr)
    return r.stdout
args=[a for a in sys.argv[1:] if not a.startswith('--')]
dry='--dry-run' in sys.argv
staged=None
if '--staged' in sys.argv: staged=sys.argv[sys.argv.index('--staged')+1]; args=[a for a in args if a!=staged]
slug,title,excerpt,tag,cat,read,cover=args
page=f'blog/{slug}.html'
if staged: shutil.copy(staged,os.path.join(REPO,page))
if not os.path.exists(os.path.join(REPO,page)): sys.exit('page not found: '+page)
run('git','fetch','-q','origin')
base=run('git','show','origin/main:blog.html'); sm=run('git','show','origin/main:sitemap.xml')
w,h=Image.open(os.path.join(REPO,cover)).size
tagh=tag.replace('&','&amp;')
card=f'''    <a class="blog-card" data-cat="{cat}" href="blog/{slug}.html">
      <img width="{w}" height="{h}" class="blog-card-img" src="{cover}" alt="Soft warm texture">
      <div class="blog-card-body">
        <div class="blog-card-tag">{tagh}</div>
        <div class="blog-card-title">{title.replace('&','&amp;')}</div>
        <div class="blog-card-excerpt">{excerpt.replace('&','&amp;')}</div>
        <div class="blog-card-meta">{read}</div>
      </div>
    </a>

'''
if f'blog/{slug}.html' not in base:
    m='    <a class="blog-card"'
    i=base.index(m); base=base[:i]+card+base[i:]
loc=f'  <url><loc>https://myhaloapp.co.uk/blog/{slug}.html</loc></url>'
if loc not in sm:
    anchor='  <url><loc>https://myhaloapp.co.uk/blog.html</loc></url>\n'
    sm=sm.replace(anchor,anchor+loc+'\n',1)
if dry: print('DRY RUN ok:',slug,len(base),len(sm)); sys.exit(0)
open(os.path.join(REPO,'blog.html'),'w').write(base); open(os.path.join(REPO,'sitemap.xml'),'w').write(sm)
run('git','add',page,'blog.html','sitemap.xml',cover)
run('git','commit','-q','-m',f'Publish: {title}\n\nCo-Authored-By: Claude Sonnet 5.5 <noreply@anthropic.com>')
run('git','pull','--rebase','-q','origin','main',check=False)
run('git','push','-q','origin','HEAD:main')
url=f'https://myhaloapp.co.uk/blog/{slug}.html'
for _ in range(30):
    try:
        if urllib.request.urlopen(url,timeout=15).status==200: print('LIVE:',url); sys.exit(0)
    except Exception: pass
    time.sleep(10)
sys.exit('pushed but not live yet: '+url)

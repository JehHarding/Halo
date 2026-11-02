#!/usr/bin/env python3
"""Publishes every scheduled blog that is due (date <= today, UTC) and not yet live.
Moves scheduled-blogs/SLUG.html to blog/, adds its card to blog.html and a line to sitemap.xml."""
import json, os, datetime
from PIL import Image
today=datetime.datetime.utcnow().date().isoformat()
published=[]
for date,slug,title,exc,tag,cat,read,cover in json.load(open('scheduled-blogs/manifest.json')):
    src=f'scheduled-blogs/{slug}.html'; dst=f'blog/{slug}.html'
    if date>today or os.path.exists(dst) or not os.path.exists(src): continue
    w,h=Image.open(f'images/blog-covers/{cover}.webp').size
    esc=lambda s:s.replace('&','&amp;')
    card=f'''    <a class="blog-card" data-cat="{cat}" href="blog/{slug}.html">
      <img width="{w}" height="{h}" class="blog-card-img" src="images/blog-covers/{cover}.webp" alt="Soft warm texture">
      <div class="blog-card-body">
        <div class="blog-card-tag">{esc(tag)}</div>
        <div class="blog-card-title">{esc(title)}</div>
        <div class="blog-card-excerpt">{esc(exc)}</div>
        <div class="blog-card-meta">{read}</div>
      </div>
    </a>

'''
    b=open('blog.html').read()
    if f'blog/{slug}.html' not in b:
        i=b.index('    <a class="blog-card"'); b=b[:i]+card+b[i:]; open('blog.html','w').write(b)
    s=open('sitemap.xml').read()
    loc=f'  <url><loc>https://myhaloapp.co.uk/blog/{slug}.html</loc></url>'
    if loc not in s:
        a='  <url><loc>https://myhaloapp.co.uk/blog.html</loc></url>\n'
        open('sitemap.xml','w').write(s.replace(a,a+loc+'\n',1))
    os.replace(src,dst); published.append(title)
open(os.environ.get('GITHUB_OUTPUT','/dev/null'),'a').write('titles='+'; '.join(published)+'\n')
print('Published:',published or 'nothing due')

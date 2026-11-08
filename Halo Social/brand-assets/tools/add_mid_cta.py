#!/usr/bin/env python3
"""Adds one in-article call to action roughly halfway through every blog page (idempotent).
Usage: add_mid_cta.py [dir ...]   (default: blog scheduled-blogs)"""
import re, sys, glob, os
MARK='<!-- halo-mid-cta -->'
BLOCK=MARK+'''
      <div class="post-mid-cta" style="background:var(--rose-ll);border:1px solid rgba(201,137,122,.25);border-radius:16px;padding:26px 28px;margin:40px 0;text-align:center">
        <div style="font-family:'Cormorant Garamond',serif;font-size:24px;line-height:1.3;color:var(--dark);margin-bottom:8px">Keep your pet's weight, medication and notes in one place</div>
        <p style="margin:0 0 16px;font-size:14.5px;line-height:1.6">{HALO} is free to download for one pet.</p>
        <a class="post-cta-btn app-store-link" style="color:#fff!important;border-bottom:none" href="https://apps.apple.com/app/halo-pet-health/id6788889183" target="_blank" rel="noopener">Get Halo, free</a>
      </div>
'''
HALO='<a class="app-store-link" href="https://apps.apple.com/app/halo-pet-health/id6788889183" target="_blank" rel="noopener">Halo</a>'
def add(html):
    if MARK in html: return html,False
    a=html.find('<div class="post-body">'); b=html.find('<div class="post-cta">')
    if a<0 or b<0: return html,False
    body=html[a:b]
    h2=[m.start() for m in re.finditer(r'\n\s*<h2',body)]
    if len(h2)<2: return html,False
    pos=a+h2[len(h2)//2]
    return html[:pos]+'\n'+BLOCK.replace('{HALO}',HALO)+html[pos:],True
if __name__=='__main__':
    n=0
    for d in sys.argv[1:] or ['blog','scheduled-blogs']:
        for f in glob.glob(d+'/*.html'):
            h=open(f).read(); h2,ch=add(h)
            if ch: open(f,'w').write(h2); n+=1
    print('updated',n)

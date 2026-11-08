# Builds a Halo blog post from the live gradual-weight-loss page used as a template.
# Usage: exec(open(this_file).read()); build(...); output goes to outdir (stage in Halo Social/posts/..., move to blog/ to publish).
import re
SRC='/Users/mrsharding/Documents/Code/Halo Website/blog/gradual-weight-loss-warning-sign.html'
tpl=open(SRC).read()
def build(slug,title,title_br,desc,date,tag,read,lede,body,cta_title,cta_sub,related,outdir):
    t=tpl
    old_title=re.search(r'<title>(.*?)</title>',t).group(1).replace(', Halo','')
    t=t.replace('A slow decline is almost invisible day to day. Why monthly weigh-ins catch what a glance at your pet never will.',desc)
    t=t.replace(old_title+', Halo',title+', Halo').replace(old_title,title)
    t=t.replace('gradual-weight-loss-warning-sign.html',slug+'.html')
    t=t.replace('"datePublished": "2026-07-28"','"datePublished": "%s"'%date)
    a0=t.index('<article>'); a1=t.index('</article>')+len('</article>')
    art=f'''<article>
    <header class="post-hero">
      <div class="post-tag">{tag}</div>
      <h1 class="post-title">{title_br}</h1>
      <div class="post-meta"><span>{read} min read</span></div>
      <p class="post-hero-lede">{lede}</p>
    </header>
    <div class="post-body">
{body}
    </div>
    <div class="post-cta">
      <div class="post-cta-inner">
        <div class="post-cta-title">{cta_title}</div>
        <p class="post-cta-sub">{cta_sub}</p>
        <a class="post-cta-btn app-store-link" href="https://apps.apple.com/app/halo-pet-health/id6788889183" target="_blank" rel="noopener">Get Halo</a>
      </div>
    </div>
    <div class="post-related">
      <div class="post-related-h">More from the journal</div>
      <div class="post-related-grid">
{related}
      </div>
    </div>
  </article>'''
    t=t[:a0]+art+t[a1:]
    open(outdir+slug+'.html','w').write(t)
VET='''      <div class="post-vet-notice">
        <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><path d="M12 9v4"/><path d="M12 17h.01"/><path d="M10.29 3.86 1.82 18a2 2 0 0 0 1.71 3h16.94a2 2 0 0 0 1.71-3L13.71 3.86a2 2 0 0 0-3.42 0z"/></svg>
        <span>%s</span>
      </div>'''
HALO='<a class="app-store-link" href="https://apps.apple.com/app/halo-pet-health/id6788889183" target="_blank" rel="noopener">Halo</a>'
def rel(items):
    return '\n'.join(f'''        <a class="post-related-card" href="{h}">
          <div class="post-related-tag">{tg}</div>
          <div class="post-related-title">{ti}</div>
        </a>''' for h,tg,ti in items)

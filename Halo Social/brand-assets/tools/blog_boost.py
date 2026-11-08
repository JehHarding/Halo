#!/usr/bin/env python3
"""Adds to blog pages (idempotent): Quick answer box, inline links to related live posts, free printable box."""
import re, glob, os
ROOT='/Users/mrsharding/Documents/Code/Halo Website/'
QUICK={
'how-often-to-weigh-your-cat':"Monthly is right for most cats. Weigh more often if your cat has a health condition, a recent medication change, a change in eating, or is a senior.",
'resting-breathing-rate-cats':"Count your cat's breaths for 15 seconds while they are fully relaxed or asleep, then multiply by four. Write the number down and watch the trend.",
'resting-breathing-rate-cats-vs-dogs':"Count breaths for 15 seconds at rest and multiply by four. Cats are usually around 20 to 30 breaths a minute and dogs around 10 to 35, but a rising trend matters more than any one number.",
'gradual-weight-loss-warning-sign':"Slow weight loss is easy to miss by eye, and an unexplained drop can be an early sign of illness. Weigh regularly and tell your vet about a steady downward trend.",
'when-to-call-the-vet-now':"Call your vet straight away for effortful or open-mouth breathing, repeated straining with nothing coming out, and the other red flags below. Most changes can wait for a normal appointment.",
'what-counts-as-old-for-a-cat':"Vets treat 7 to 10 as mature, 10 to 14 as senior and 14 and over as geriatric, but the number matters less than how your individual cat is doing.",
'how-to-give-a-cat-a-pill':"Wrap the pill fully in a pill pocket or strong-smelling wet food, have a plan before you start (a towel or a helper), and follow with food or water so it does not stick.",
'why-is-my-cat-breathing-fast-while-asleep':"A healthy sleeping cat usually takes about 15 to 30 breaths a minute, and a settled cat consistently above 30 is worth mentioning to your vet. Dreaming, warmth and a recent meal can all make it look worse than it is.",
'what-to-do-about-a-missed-dose':"If it is close to the missed time, it is often fine to give it when you remember. If the next dose is close, it is often better to skip it. Never double up unless your vet says so.",
'cat-sitter-checklist':"Give your sitter every medication with its dose and time, your vet and an out-of-hours vet, and a description of what normal looks like for your pet.",
'bonfire-night-keep-any-pet-calm':"Plan ahead: walk dogs in daylight, keep cats and small pets safely in, make a quiet hiding place, and talk to your vet early if your pet struggles every year.",
'fireworks-tonight-last-minute-checklist':"Walk dogs in daylight, feed early, check the microchip, keep cats in, bring small pets inside, close the curtains and give your pet a quiet hiding place.",
'tortoise-hibernation-why-weighing-matters':"Get a vet check and weigh-in before hibernation, weigh regularly during it, and ask your vet which weight loss limit applies. A little loss is normal, too much is a warning.",
'is-your-dog-overweight-how-to-tell':"You should feel your dog's ribs easily under a thin layer, see a waist from above and a tucked tummy from the side. Thick coats can fool you, so feel as well as look.",
'keeping-rabbits-and-small-pets-warm-in-winter':"Keep the hutch dry, off the ground and out of the wind, add extra hay (not blankets), stop water freezing, and check your rabbits several times a day.",
'senior-dogs-and-arthritis-the-signs':"Slowing down, stiffness after rest, limping and reluctance to walk or climb stairs can all point to arthritis. See your vet, because pain can be treated.",
'helping-a-pet-lose-weight-safely':"Start with your vet, measure food and treats, and aim for slow, steady loss. Cats in particular should never be put on a crash diet.",
'christmas-hazards-for-pets':"Keep chocolate, raisins and sultanas, onions, sweeteners, cooked bones, tinsel, lilies and batteries away from pets, and call your vet straight away if something is eaten.",
'packing-your-pets-medication-for-christmas-away':"Take enough medication plus a few spare days, keep it in its labelled packaging, write the routine down, and find an out-of-hours vet near where you are staying.",
'winter-dog-walks-safety':"Be visible in the dark, wash grit and salt off paws, keep dogs off frozen water, lock away antifreeze, and shorten walks for puppies, seniors and thin-coated dogs.",
'why-pets-gain-or-lose-weight-in-winter':"Less exercise and extra treats can add weight, while outdoor animals and older pets can lose it. Thick winter coats hide both, so use the scales.",
'pet-health-myth-or-fact':"A dry nose does not mean a sick dog, a wagging tail does not always mean happy, and rabbits should not live on carrots. Chocolate really is dangerous for pets.",
'horses-in-winter-weight-and-rugging':"Check condition by feel under the coat, rug for the horse and not the calendar, take rugs off daily to check underneath, and make sure forage and water are always available.",
'leaving-your-pet-with-a-sitter-over-christmas':"Write down the routine, every medication, your vet and out-of-hours vet, and what is normal for your pet, and let your sitter meet them before you leave.",
'finding-your-out-of-hours-vet-before-christmas':"Find out who covers your vet out of hours, save their address and number in your phone now, and have medication, weights and insurance details ready to bring.",
'new-years-eve-fireworks-pet-plan':"Walk dogs early, set up a quiet den, keep cats in, bring small pets inside, stay calm yourself, and talk to your vet well ahead if your pet struggles every year.",
'new-year-new-pet-health-records':"Gather vaccination dates, medications, recent weights, insurance, microchip details and your vet's contacts in one place, and weigh your pet monthly.",
}
LINKS=[ (r'resting (?:breathing|respiratory) rate','resting-breathing-rate-cats'),
 (r'weigh your cat','how-often-to-weigh-your-cat'), (r'when to call the vet','when-to-call-the-vet-now'),
 (r'senior cat','senior-cat-checklist'), (r'emergency kit','pet-emergency-kit-checklist'),
 (r'cat sitter','cat-sitter-checklist'), (r'missed dose','what-to-do-about-a-missed-dose'),
 (r'Bonfire Night','bonfire-night-keep-any-pet-calm'), (r'gradual weight loss','gradual-weight-loss-warning-sign'),
 (r'GI stasis','rabbit-gi-stasis-explained'), (r'senior dog','senior-dog-checklist'),
 (r'colic','colic-in-horses-emergency-signs'), (r'storing (?:your )?medication','storing-medication-properly'),
 (r'prescription label','reading-a-vets-prescription-label')]
PRINT_FILES={'leaving-your-pet-with-a-sitter-over-christmas','cat-sitter-checklist','boarding-vs-a-sitter','packing-your-pets-medication-for-christmas-away','finding-your-out-of-hours-vet-before-christmas'}
QB='<!-- halo-quick-answer -->\n      <div class="post-quick" style="background:var(--card);border:1px solid var(--rose-l);border-left:4px solid var(--rose);border-radius:12px;padding:18px 22px;margin:0 0 32px;font-size:15px;line-height:1.7;color:var(--dark)"><strong style="color:var(--rose)">Quick answer</strong><br>{T}</div>\n'
PB='<!-- halo-printable -->\n      <div class="post-printable" style="background:var(--card);border:1px solid var(--rose-l);border-radius:12px;padding:18px 22px;margin:32px 0;font-size:15px;line-height:1.7;color:var(--dark)"><strong style="color:var(--rose)">Free printable</strong><br>Fill in our <a class="internal-link" href="../downloads/Halo-Pet-Sitter-Handover-Sheet.pdf" target="_blank" rel="noopener">pet sitter handover sheet (PDF)</a> once and leave it on the counter for your sitter.</div>\n'
live=lambda s: os.path.exists(ROOT+'blog/'+s+'.html')
def inline(body,slug):
    keep={}
    def stash(m): k=f'@@{len(keep)}@@'; keep[k]=m.group(0); return k
    body=re.sub(r'<!-- halo-(?:mid-cta|quick-answer|printable) -->\n\s*<div class="post-(?:mid-cta|quick|printable)".*?\n?\s*</div>\n',stash,body,flags=re.S) if False else body
    parts=re.split(r'(<[^>]+>)',body); out=[]; depth_a=0; skip=0; used=0; usedslugs=set()
    stack=[]
    for p in parts:
        if p.startswith('<'):
            t=p.lower()
            if re.match(r'<(a|h1|h2|h3|strong|script|style)\b',t): skip+=1
            if re.match(r'</(a|h1|h2|h3|strong|script|style)>',t): skip=max(0,skip-1)
            out.append(p); continue
        if skip or used>=3 or not p.strip(): out.append(p); continue
        for pat,target in LINKS:
            if used>=3: break
            if target==slug or target in usedslugs or not live(target): continue
            m=re.search(r'\b('+pat+r')\b',p,flags=re.I)
            if m:
                p=p[:m.start()]+f'<a class="internal-link" href="{target}.html">{m.group(1)}</a>'+p[m.end():]
                usedslugs.add(target); used+=1
        out.append(p)
    return ''.join(out)
n=dict(q=0,l=0,p=0)
for f in glob.glob(ROOT+'blog/*.html')+glob.glob(ROOT+'scheduled-blogs/*.html'):
    slug=os.path.basename(f)[:-5]; s=open(f).read(); orig=s
    a=s.find('<div class="post-body">'); b=s.find('<div class="post-cta">')
    if a<0 or b<0: continue
    start=a+len('<div class="post-body">'); body=s[start:b]
    if '<!-- halo-inline-links -->' not in s:
        # protect injected boxes
        boxes=[]
        def st(m): boxes.append(m.group(0)); return f'@@BOX{len(boxes)-1}@@'
        prot=re.sub(r'<!-- halo-(?:mid-cta|quick-answer|printable) -->.*?</div>\n',st,body,flags=re.S)
        prot=inline(prot,slug)
        for i,bx in enumerate(boxes): prot=prot.replace(f'@@BOX{i}@@',bx)
        if prot!=body: n['l']+=1
        body=prot.replace('\n','\n',1)
        s=s[:start]+body+s[b:]; 
        s=s.replace('<div class="post-body">','<div class="post-body"><!-- halo-inline-links -->',1)
        a=s.find('<div class="post-body">'); b=s.find('<div class="post-cta">'); start=a+len('<div class="post-body"><!-- halo-inline-links -->'); body=s[start:b]
    if slug in QUICK and '<!-- halo-quick-answer -->' not in s:
        s=s.replace('<!-- halo-inline-links -->','<!-- halo-inline-links -->\n'+QB.replace('{T}',QUICK[slug]),1); n['q']+=1
    if slug in PRINT_FILES and '<!-- halo-printable -->' not in s:
        m=re.search(r'\n\s*<div class="post-vet-notice">',s)
        if m: s=s[:m.start()]+'\n'+PB+s[m.start():]; n['p']+=1
    if s!=orig: open(f,'w').write(s)
print(n)

import re
exec(open('/Users/mrsharding/Documents/Code/Halo Website/Halo Social/brand-assets/tools/blog_builder.py').read())
B='/Users/mrsharding/Documents/Code/Halo Website/blog/'
OUT='/Users/mrsharding/Documents/Code/Halo Website/Halo Social/posts/thursday-blogs/'
def R(*slugs):
    items=[]
    for s in slugs:
        import os
        t=open(B+s+'.html' if os.path.exists(B+s+'.html') else OUT+s+'.html').read()
        ti=re.search(r'<title>(.*?), Halo</title>',t).group(1)
        tg=re.search(r'post-tag">([^<]*)',t).group(1)
        items.append((s+'.html',tg,ti))
    return rel(items)
def V(t): return VET % t
H='Health &amp; Symptoms'; C='Care &amp; Travel'
def em(h): # h2 with italic tail
    a,b=h.rsplit('|',1); return f'      <h2>{a}<em>{b}</em></h2>'
def post(slug,title,br,desc,date,tag,read,lede,body,cta,sub,related):
    assert '—' not in body+lede+desc
    build(slug,title,br,desc,date,tag,read,lede,body,cta,sub,R(*related),OUT)

# 1 weight loss
post('helping-a-pet-lose-weight-safely','Helping a Pet Lose Weight Safely','Helping a Pet<br>Lose Weight Safely',
 'Why you see the vet first, how to cut calories slowly, and how weekly weigh-ins show whether the plan is working.','2026-11-17',H,'4',
 'Extra weight puts strain on joints, hearts and breathing. The good news is that it can be fixed, as long as it is done slowly and with your vet.',
f'''      <h2>Start with <em>your vet</em></h2>
      <p>Before changing anything, have your vet check your pet over. Some conditions cause weight gain, and a pet that needs to lose weight may also need a different plan for other health reasons. Your vet can set a target weight and tell you how fast is safe.</p>
      <h2>Slow is <em>safe</em></h2>
      <p>Crash diets are risky. Cats in particular can become seriously ill if they stop eating or lose weight too fast, so never cut your cat's food drastically on your own. Gradual loss, agreed with your vet, is the aim for every pet.</p>
      <h2>What actually <em>helps</em></h2>
      <ul>
        <li><strong>Measure the food.</strong> Use scales or a proper measuring cup, not a scoop that is a bit different every day.</li>
        <li><strong>Count the treats.</strong> They add up quickly. Use part of the daily food allowance as treats, or ask your vet what is sensible.</li>
        <li><strong>One feeder.</strong> If several people feed your pet, agree who does what, so nobody tops up without knowing.</li>
        <li><strong>Move more.</strong> More play for cats, extra walks or fetch for dogs, within what your vet says is right for them.</li>
        <li><strong>Check the food label</strong> and ask your vet whether a weight management food would suit.</li>
      </ul>
      <div class="post-callout">
        <strong>Weigh regularly:</strong> weigh at the same time of day, on the same scales, and write it down. One reading means little. The trend over weeks is what tells you the plan is working.
      </div>
{V("This guide is for information only and isn't veterinary advice. Always agree a weight loss plan with your vet before changing your pet's diet.")}
      <h2>Keep going, <em>and keep track</em></h2>
      <p>Progress can feel slow, so a chart helps. {HALO} records each weigh-in and shows the trend, so you can see the plan working and show your vet at the next check.</p>''',
 'See the trend, not just the number','Halo charts your pet\'s weight over time so slow progress becomes visible.',
 ['gradual-weight-loss-warning-sign','how-often-to-weigh-your-cat','weighing-different-sized-pets'])

# 2 personal
post('what-living-with-a-cat-with-a-heart-condition-taught-me','What Living With a Cat With a Heart Condition Taught Me','What Living With a Cat<br>With a Heart Condition<br>Taught Me',
 'Angel has a complex congenital heart condition and has just turned seven. The habits that helped most, from counting breaths to writing things down.','2026-11-24','Behind Halo','4',
 'My cat Angel was diagnosed with a complex congenital heart condition in 2020. She has just turned seven. Here is what I have learned along the way.',
f'''      <h2>Count the breaths, <em>every time</em></h2>
      <p>The most useful thing I was ever asked to do was count Angel's breathing while she was asleep and relaxed. Her vets explained that a resting rate that creeps up can be an early warning, long before anything looks wrong. A number I could report beat "she seems a bit off".</p>
      <h2>Write it all <em>down</em></h2>
      <p>Appointments are short and I am nervous in them. Having her weights, her medications and a log of how she has been meant I never had to rely on memory. When a new vet saw her, I could hand over the whole picture.</p>
      <h2>Quiet is not <em>always fine</em></h2>
      <p>Cats hide how they feel. A cat who sleeps more, hides, or stops doing a small thing she always did is telling you something. I learned to trust that feeling and ask, even when it turned out to be nothing.</p>
      <h2>You are allowed to <em>ask questions</em></h2>
      <p>I used to leave appointments with questions I had not dared to ask. Now I write them down beforehand: what changes should worry me, what is normal for her, and when I should call rather than wait.</p>
      <h2>Ordinary days <em>matter most</em></h2>
      <p>Living with a serious condition is mostly ordinary days: medication, meals, naps in the sun. Getting the routine right is what lets the ordinary days keep happening.</p>
{V("This is one person's experience and isn't veterinary advice. Every pet's condition is different. Always follow your own vet's guidance.")}
      <h2>Why I built <em>Halo</em></h2>
      <p>All of this is why I made {HALO}: a breathing-rate counter, weights, medications and a daily log, in one calm place. If you are looking after a pet with a long-term condition, I hope it makes the days a little easier.</p>''',
 'Built from living it','Halo started with Angel. It is free to download for one pet.',
 ['built-by-one-person-and-her-cat','heart-disease-signs-cats','resting-breathing-rate-cats'])

# 3 christmas hazards
post('christmas-hazards-for-pets','Christmas Hazards for Pets','Christmas Hazards<br>for Pets',
 'Chocolate, raisins, tinsel, lilies and more. The common Christmas dangers for dogs, cats and small pets, and what to do if something is eaten.','2026-12-01',C,'4',
 'Christmas is full of things that are fine for us and dangerous for pets. A quick walk round the house now saves a stressful call to the vet later.',
f'''      <h2>In the <em>kitchen</em></h2>
      <ul>
        <li><strong>Chocolate</strong> is toxic to dogs and cats. Dark chocolate is the most dangerous.</li>
        <li><strong>Grapes, raisins, currants and sultanas</strong> are toxic to dogs. That includes mince pies, Christmas cake and pudding.</li>
        <li><strong>Onions, garlic and leeks</strong> are harmful to dogs and cats, so keep stuffing and gravy away.</li>
        <li><strong>Sweeteners</strong> such as xylitol, found in some sugar-free foods, are very dangerous to dogs.</li>
        <li><strong>Cooked bones</strong> can splinter and cause injury or blockage.</li>
        <li><strong>Alcohol</strong> and fatty leftovers should stay out of reach.</li>
      </ul>
      <h2>In the <em>living room</em></h2>
      <ul>
        <li><strong>Tinsel, ribbon and string</strong> are tempting to cats and can cause a serious blockage if swallowed.</li>
        <li><strong>Lilies</strong> are very dangerous to cats, even a little pollen. Check bouquets.</li>
        <li><strong>Holly, mistletoe and ivy</strong> can upset a pet's stomach.</li>
        <li><strong>Tree water, wires and batteries</strong> are worth keeping out of reach. Chewed cables and swallowed batteries are emergencies.</li>
        <li><strong>Ornaments and small gifts</strong> can be chewed or swallowed.</li>
      </ul>
      <div class="post-callout">
        <strong>If something has been eaten:</strong> call your vet or out-of-hours vet straight away, even if your pet seems fine. Tell them what, and roughly how much. Do not wait for symptoms.
      </div>
{V("This guide is for information only and isn't veterinary advice. If you think your pet has eaten something harmful, contact your vet immediately.")}
      <h2>Be ready <em>just in case</em></h2>
      <p>Know where your out-of-hours vet is before you need it. And if your pet takes regular medication, check you have enough to get through the holiday. {HALO} keeps their medication and vet details in one place.</p>''',
 'Be ready for the holidays','Keep your pet\'s medication, weight and vet details in one place with Halo.',
 ['pet-emergency-kit-checklist','emergency-prep-checklist','when-to-call-the-vet-now'])

# 4 pack medication
post('packing-your-pets-medication-for-christmas-away','Packing Your Pet\'s Medication for Christmas Away','Packing Your Pet\'s<br>Medication for<br>Christmas Away',
 'Enough supply, the right packaging, a written schedule and a plan if you run out. How to take a pet on medication away for the holidays.','2026-12-03',C,'4',
 'Going away for Christmas with a pet on medication takes a little planning, mostly because vets and pharmacies close. Do the checking now, not on Christmas Eve.',
f'''      <h2>Check the <em>supply</em></h2>
      <p>Look at how much medication you have and when it runs out. Take enough for the whole trip plus a few spare days in case you are delayed. If it will run short, ask your vet for a repeat prescription well before the practice closes for the holidays.</p>
      <h2>Keep it <em>in its packaging</em></h2>
      <ul>
        <li>Keep medication in its original labelled packaging, with the dose instructions.</li>
        <li>Check storage. Some medicines need to be kept cool or away from sunlight.</li>
        <li>Keep it in your hand luggage or the car cabin, not the boot.</li>
        <li>Keep it out of reach of children and other pets where you are staying.</li>
      </ul>
      <h2>Write the <em>routine</em> down</h2>
      <p>Write out each medication, the dose and the times, and note anything that has changed recently. If someone else will be giving a dose, they should not have to guess. A written schedule also helps if you need to see a vet away from home.</p>
      <h2>Keep to the <em>usual times</em></h2>
      <p>A busy day with visitors is exactly when a dose gets missed. Set phone alarms at the usual times, and keep the same routine as far as you can.</p>
      <div class="post-callout">
        <strong>Know your plan B:</strong> save the number of the vet at home, and find an out-of-hours vet near where you are staying before you set off.
      </div>
{V("This guide is for information only and isn't veterinary advice. Ask your vet if you are unsure how to store, dose or travel with your pet's medication.")}
      <h2>One place for <em>all of it</em></h2>
      <p>{HALO} keeps your pet's medications, doses, schedule and vet details together, so everything you need for the trip is in your pocket.</p>''',
 'Take it all with you','Halo keeps medications, doses and vet details together.',
 ['flying-with-a-pet-on-medication','storing-medication-properly','what-to-do-about-a-missed-dose'])

# 5 winter walks
post('winter-dog-walks-safety','Winter Dog Walks: Staying Safe in the Cold and Dark','Winter Dog Walks:<br>Staying Safe in the<br>Cold and Dark',
 'Visibility, paws, ice, antifreeze and which dogs feel the cold most. A practical guide to winter walks.','2026-12-08',H,'4',
 'Winter walks are still some of the best parts of the day. A few small changes keep them safe and comfortable for you and your dog.',
f'''      <h2>Be <em>seen</em></h2>
      <p>With short days, many walks happen in the dark. Wear something bright or reflective yourself, and use a light-up collar, a reflective coat or a clip-on light on your dog. Keep your dog on a lead near roads.</p>
      <h2>Look after the <em>paws</em></h2>
      <ul>
        <li>Rinse and dry paws after walks. Grit, salt and de-icers can irritate skin and are harmful if licked off.</li>
        <li>Check between the toes for ice balls and small cuts.</li>
        <li>Keep antifreeze locked away. It is extremely poisonous and tastes sweet to pets.</li>
      </ul>
      <h2>Ice and <em>water</em></h2>
      <p>Frozen ponds and lakes look like solid ground, but ice can break. Keep your dog away from them, and never go onto the ice to rescue a dog. Call for help instead.</p>
      <h2>Some dogs feel the cold <em>more</em></h2>
      <p>Puppies, seniors, thin or short-coated dogs, and dogs with health conditions get cold quicker. A coat can help, and shorter, more frequent walks are often better than one long one. If your dog shivers, slows down or lifts their paws, head home.</p>
      <div class="post-callout">
        <strong>Stiff on cold mornings?</strong> Joint pain can show up more in cold weather. If your dog seems slower than usual, mention it to your vet.
      </div>
{V("This guide is for information only and isn't veterinary advice. If your dog seems unwell after a walk, contact your vet.")}
      <h2>Keep an eye on <em>weight</em></h2>
      <p>Shorter walks can mean weight creeping on over winter. Weigh your dog regularly and log it in {HALO}, so changes are spotted early.</p>''',
 'Track the winter weight','Halo charts your dog\'s weight so changes show early.',
 ['senior-dog-checklist','how-dogs-hide-pain','dog-body-language-basics'])

# 6 winter weight
post('why-pets-gain-or-lose-weight-in-winter','Why Pets Gain or Lose Weight in Winter','Why Pets Gain or<br>Lose Weight in Winter',
 'Less exercise, more treats, thick coats and colder weather. Why winter changes your pet\'s weight, and how to stay on top of it.','2026-12-10',H,'3',
 'Winter changes routines for people and pets alike, and weight often follows. Some pets gain, some lose, and thick winter coats can hide both.',
f'''      <h2>Why some pets <em>gain</em></h2>
      <ul>
        <li>Shorter days and colder weather mean less walking and play.</li>
        <li>Festive treats and scraps add up quickly.</li>
        <li>Indoor pets stay home more, with food always nearby.</li>
      </ul>
      <h2>Why some pets <em>lose</em></h2>
      <ul>
        <li>Pets that live outside, such as horses and rabbits, use more energy to stay warm.</li>
        <li>Older pets can find cold weather harder, and may eat less.</li>
        <li>Illness can cause weight loss at any time, and winter can hide it.</li>
      </ul>
      <h2>The coat can <em>fool you</em></h2>
      <p>A fluffy winter coat can hide a pet getting thinner or heavier. Looking is not enough. Feel along the ribs and spine, and use the scales where you can.</p>
      <div class="post-callout">
        <strong>When to call the vet:</strong> unexplained weight loss, or weight gain without a change in food, is worth a call. Do not wait for spring.
      </div>
{V("This guide is for information only and isn't veterinary advice. Talk to your vet about any unexplained change in your pet's weight.")}
      <h2>Weigh through the <em>winter</em></h2>
      <p>A regular weigh-in tells you what your eyes cannot. {HALO} keeps every weight in one place and charts the trend, so you can spot a change early and show your vet.</p>''',
 'Spot the change early','Halo charts your pet\'s weight over time.',
 ['gradual-weight-loss-warning-sign','how-often-to-weigh-your-cat','weighing-different-sized-pets'])

# 7 myth or fact
post('pet-health-myth-or-fact','Pet Health: Myth or Fact?','Pet Health:<br>Myth or Fact?',
 'Dry noses, wagging tails, purring, carrots for rabbits, dog years and chocolate. Six common pet beliefs, sorted into myth and fact.','2026-12-15',H,'3',
 'Some things about pets get repeated so often that we assume they are true. Here are six, sorted.',
f'''      <h2>A dry nose means a sick dog. <em>Myth</em></h2>
      <p>A dog's nose changes through the day. A warm or dry nose on its own does not tell you much. Look at appetite, energy, drinking and toilet habits instead.</p>
      <h2>A wagging tail means a happy dog. <em>Myth</em></h2>
      <p>Tails wag when a dog is excited, nervous or even aroused. What matters is the whole body: posture, ears and the speed and height of the wag.</p>
      <h2>Cats only purr when they are happy. <em>Myth</em></h2>
      <p>Cats often purr when content, but they can also purr when stressed, unwell or in pain. Look at the rest of their behaviour.</p>
      <h2>Rabbits live on carrots. <em>Myth</em></h2>
      <p>The bulk of a rabbit's diet should be hay or grass, with some fresh greens. Carrots are a sugary treat, so only a little.</p>
      <h2>One dog year equals seven human years. <em>Myth</em></h2>
      <p>The rule of thumb is too simple. Dogs age differently depending on size and breed, and larger dogs tend to age faster.</p>
      <h2>Chocolate is dangerous for pets. <em>Fact</em></h2>
      <p>Chocolate contains theobromine, which is toxic to dogs and cats. Dark chocolate is the most dangerous. If your pet eats some, call your vet.</p>
{V("This guide is for information only and isn't veterinary advice. If you are worried about your pet, speak to your vet.")}
      <h2>Facts beat <em>guesses</em></h2>
      <p>The best way to know what is normal for your pet is to track it. {HALO} records weight, breathing rate and daily notes, so you are working from facts.</p>''',
 'Know what\'s normal for your pet','Halo tracks the facts: weight, breathing and daily notes.',
 ['cat-body-language-basics','dog-body-language-basics','rabbit-body-language-basics'])

# 8 horses
post('horses-in-winter-weight-and-rugging','Horses in Winter: Weight and Rugging','Horses in Winter:<br>Weight and Rugging',
 'Keeping condition on in the cold, checking under rugs, forage and fresh water. A winter guide for horse owners.','2026-12-17',C,'4',
 'Winter is when weight and condition can slip, or when rugs hide problems. A few regular checks keep your horse comfortable.',
f'''      <h2>Check condition by <em>feel</em></h2>
      <p>A thick winter coat hides weight loss. Feel along the ribs, spine and hindquarters to judge condition, and use a weigh tape or weighbridge if you can. Write the result down so you can compare week to week.</p>
      <h2>Rug for the horse, <em>not the calendar</em></h2>
      <ul>
        <li>Not every horse needs a rug. Overrugging can leave a horse too warm.</li>
        <li>Check the rug fits and is not rubbing, especially at the shoulders and withers.</li>
        <li>Take rugs off and check underneath every day. Feel for weight loss, sores and dampness.</li>
        <li>Change a wet rug. A damp rug is worse than none.</li>
      </ul>
      <h2>Forage is the <em>heater</em></h2>
      <p>Digesting forage helps horses keep warm, so make sure there is plenty of good hay or grazing. Cold weather can mean a horse needs more feed, and older horses and poor doers may need extra attention.</p>
      <h2>Water that <em>isn't frozen</em></h2>
      <p>Check water troughs twice a day and break any ice. Horses drink less when water is very cold, and that raises the risk of colic.</p>
      <div class="post-callout">
        <strong>Call your vet if:</strong> your horse is losing weight, off their food, shivering, or showing signs of colic.
      </div>
{V("This guide is for information only and isn't veterinary advice. Ask your vet about your horse's feeding, rugging and weight.")}
      <h2>Keep a record <em>through winter</em></h2>
      <p>{HALO} lets you log weight, vital signs and notes for each horse, so changes through winter are easy to see.</p>''',
 'Track every horse','Halo keeps weights, vitals and notes for each of your horses.',
 ['tracking-a-horses-vital-signs','colic-in-horses-emergency-signs','horse-medication-routine-livery'])

# 9 sitter
post('leaving-your-pet-with-a-sitter-over-christmas','Leaving Your Pet With a Sitter Over Christmas','Leaving Your Pet<br>With a Sitter<br>Over Christmas',
 'What to write down for a Christmas pet sitter: routine, medications, vet details and what to do in an emergency.','2026-12-22',C,'4',
 'A good handover makes Christmas easier for everyone, especially a pet on medication. Here is what your sitter needs to know.',
f'''      <h2>The <em>routine</em></h2>
      <p>Write down feeding times and amounts, walks, play, and any habits. Keep it as close as you can to normal. Pets cope better with change when the day follows a familiar pattern.</p>
      <h2>Medications, <em>clearly</em></h2>
      <ul>
        <li>The name, dose and time of each medication.</li>
        <li>How to give it, for example with food or by mouth.</li>
        <li>What to do if a dose is missed.</li>
        <li>Where the medication is kept.</li>
      </ul>
      <h2>Who to <em>call</em></h2>
      <ul>
        <li>Your own phone number and a back-up contact.</li>
        <li>Your vet's number, and the out-of-hours vet's name, address and number.</li>
        <li>Written permission for the sitter to get treatment, and how costs will be handled.</li>
      </ul>
      <h2>What's <em>normal</em> for your pet</h2>
      <p>Tell your sitter how your pet usually looks and acts, and what would worry you. A sitter who knows the normal is far better placed to notice something wrong.</p>
      <div class="post-callout">
        <strong>Do a trial visit:</strong> let your sitter meet your pet and go through the routine with you before you leave.
      </div>
{V("This guide is for information only and isn't veterinary advice. Ask your vet what your pet's sitter should know.")}
      <h2>Put it on <em>one page</em></h2>
      <p>{HALO}'s Carer's Pack turns your pet's details, medication schedule and vet contacts into a single page for your sitter. Sharing it as a PDF is part of Halo Plus, and viewing it in the app is free.</p>''',
 'One page for your sitter','Halo\'s Carer\'s Pack puts the routine, medication and vet contacts in one place.',
 ['cat-sitter-checklist','boarding-vs-a-sitter','what-to-tell-a-new-vet'])

# 10 out of hours
post('finding-your-out-of-hours-vet-before-christmas','Finding Your Out-of-Hours Vet Before Christmas','Finding Your<br>Out-of-Hours Vet<br>Before Christmas',
 'Who covers your vet out of hours, where to find them, what to bring and how to be ready before the holidays.','2026-12-24',C,'3',
 'Emergencies do not wait for opening hours, and over Christmas most practices are closed. Find out now where you would go.',
f'''      <h2>Find out <em>who covers</em> your vet</h2>
      <p>Many practices hand over their out-of-hours calls to another clinic or service. Check your vet's website or answerphone message to find out who, and where it is.</p>
      <h2>Save it <em>in your phone</em></h2>
      <ul>
        <li>The name, address and phone number of the out-of-hours vet.</li>
        <li>How long the journey takes, and parking.</li>
        <li>Your regular vet's number, opening times and holiday closures.</li>
      </ul>
      <h2>Know what <em>to expect</em></h2>
      <p>Out-of-hours care usually costs more. Call before you go, so they can advise and be ready for you. Check your pet insurance details and what they cover.</p>
      <h2>What to <em>bring</em></h2>
      <ul>
        <li>Your pet's medications and a list of doses.</li>
        <li>Recent weights and any notes, including breathing rate if you track it.</li>
        <li>Details of any past conditions, allergies and your regular vet.</li>
        <li>Insurance details and a way to pay.</li>
      </ul>
      <div class="post-callout">
        <strong>Away from home?</strong> Look up the nearest out-of-hours vet to where you are staying before you set off.
      </div>
{V("This guide is for information only and isn't veterinary advice. In an emergency, call your vet or out-of-hours vet straight away.")}
      <h2>Have it all <em>to hand</em></h2>
      <p>{HALO} keeps your pet's medications, weights and notes together, so you can show a vet the full picture in seconds, at any hour.</p>''',
 'Everything in one place','Halo keeps your pet\'s records to hand when you need them most.',
 ['when-to-call-the-vet-now','pet-emergency-kit-checklist','what-to-tell-a-new-vet'])

# 11 NYE
post('new-years-eve-fireworks-pet-plan','New Year\'s Eve Fireworks: A Plan for Your Pet','New Year\'s Eve Fireworks:<br>A Plan for Your Pet',
 'Late-night fireworks, a safe den, early walks and what to do at midnight. A plan for keeping your pet calm on New Year\'s Eve.','2026-12-29',C,'3',
 'New Year\'s Eve means fireworks that start late and last long. A bit of planning during the day makes midnight much easier.',
f'''      <h2>Plan the <em>day</em></h2>
      <ul>
        <li>Walk dogs and let cats out early, before it gets dark and the first bangs start.</li>
        <li>Feed earlier than usual, and make sure they have been to the toilet.</li>
        <li>Check your pet's microchip details are up to date, in case they bolt.</li>
      </ul>
      <h2>Set up a <em>safe den</em></h2>
      <p>Choose a quiet room, close the curtains, and leave the radio or TV on to soften the noise. Let your pet hide if they want to, and do not pull them out.</p>
      <h2>Stay <em>calm yourself</em></h2>
      <p>Pets pick up on how you feel. Stay relaxed, and do not scold a frightened pet. Comfort them if it helps them, and keep to normal activity.</p>
      <h2>Small pets and <em>horses</em></h2>
      <p>Bring outdoor rabbits and guinea pigs into a quiet shed or garage (not with a car running) if you can, and cover part of the hutch. Talk to the yard about horses and keep to a calm routine.</p>
      <div class="post-callout">
        <strong>If your pet gets very distressed every year:</strong> talk to your vet well ahead of next time. There are options that work better than waiting until the night.
      </div>
{V("This guide is for information only and isn't veterinary advice. Speak to your vet if your pet is badly affected by fireworks.")}
      <h2>See also</h2>
      <p>For the full checklist, see our guides on <a href="bonfire-night-keep-any-pet-calm.html">Bonfire Night</a> and <a href="fireworks-tonight-last-minute-checklist.html">last-minute fireworks preparation</a>. {HALO} also keeps your pet's vet details and notes to hand if you need them.</p>''',
 'Keep it all in one place','Halo keeps your pet\'s health records handy, whatever the night brings.',
 ['bonfire-night-keep-any-pet-calm','fireworks-tonight-last-minute-checklist','emergency-prep-checklist'])

# 12 new year records
post('new-year-new-pet-health-records','New Year, New Pet Health Records','New Year,<br>New Pet Health Records',
 'The vaccinations, medications, weights, insurance and vet details to gather and keep up to date, and a simple monthly habit.','2026-12-31',C,'3',
 'The new year is a good moment to tidy your pet\'s health records, and to make one small habit that pays off all year.',
f'''      <h2>Gather the <em>basics</em></h2>
      <ul>
        <li>Vaccination dates and when the next ones are due.</li>
        <li>Current medications, doses and refill dates.</li>
        <li>Recent weights.</li>
        <li>Any conditions, allergies and past surgeries.</li>
        <li>Microchip number and the contact details it is registered to.</li>
        <li>Insurance policy details and renewal date.</li>
        <li>Your vet's details, and the out-of-hours vet.</li>
      </ul>
      <h2>Why it <em>matters</em></h2>
      <p>If your pet is ill, sees a new vet, or goes to a sitter or boarding, having everything ready saves time, and helps the vet make a better decision.</p>
      <h2>One habit for <em>the year</em></h2>
      <p>Pick a date each month to weigh your pet and write it down. Small changes show up as a pattern, long before they are obvious by eye.</p>
      <div class="post-callout">
        <strong>Diary dates:</strong> set reminders for vaccinations, check-ups and when medication runs out.
      </div>
{V("This guide is for information only and isn't veterinary advice. Your vet can tell you what checks your pet needs and when.")}
      <h2>Make it <em>easy</em></h2>
      <p>{HALO} keeps your pet's weights, medications, calendar and daily log in one place, and reminds you about the things that are easy to forget. Free for one pet.</p>''',
 'Start the year organised','Halo is free to download for one pet.',
 ['what-to-tell-a-new-vet','switching-vets-without-losing-history','one-thing-vets-ask-you-to-track'])

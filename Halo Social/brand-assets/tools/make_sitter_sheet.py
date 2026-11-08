from reportlab.lib.pagesizes import A4
from reportlab.pdfgen import canvas
from reportlab.pdfbase import pdfmetrics
from reportlab.pdfbase.ttfonts import TTFont
from reportlab.lib.colors import HexColor
FD='/Users/mrsharding/Documents/Code/Halo/Halo/Fonts/'
pdfmetrics.registerFont(TTFont('CGI',FD+'CormorantGaramond-Italic.ttf'))
pdfmetrics.registerFont(TTFont('CGL',FD+'CormorantGaramond-LightItalic.ttf'))
ROSE=HexColor('#C9897A'); DARK=HexColor('#3A3230'); LIGHT=HexColor('#CBBAA6'); LINE=HexColor('#E8C4BB')
W,H=A4; M=40
c=canvas.Canvas('/Users/mrsharding/Documents/Code/Halo Website/downloads/Halo-Pet-Sitter-Handover-Sheet.pdf',pagesize=A4)
c.setTitle('Pet Sitter Handover Sheet'); c.setAuthor('Halo')
logo='/Users/mrsharding/Documents/Code/Halo Website/Halo Social/brand-assets/outro-logo-mark.png'
c.drawImage(logo,M,H-78,width=44,height=44,mask='auto',preserveAspectRatio=True)
c.setFillColor(ROSE); c.setFont('CGI',34); c.drawString(M+56,H-62,'Pet sitter handover sheet')
c.setFillColor(DARK); c.setFont('Helvetica',9.5); c.drawString(M+56,H-78,'Fill in once and leave it where your sitter will see it.')
y=H-100
def field(label,x,y,w):
    c.setFillColor(DARK); c.setFont('Helvetica-Bold',8.5); c.drawString(x,y+3,label)
    c.setStrokeColor(LINE); c.setLineWidth(0.8); c.line(x+len(label)*4.6+6,y,x+w,y)
def two(l1,l2,y):
    field(l1,M,y,(W-2*M)/2-10); field(l2,M+(W-2*M)/2+10,y,(W-2*M)/2-10)
def head(t,y):
    c.setFillColor(ROSE); c.setFont('CGI',17); c.drawString(M,y,t); c.setStrokeColor(LINE); c.line(M,y-4,W-M,y-4)
head('About my pet',y); y-=26
two('Name:','Species / age:',y); y-=24
field('Feeding (what, how much, when):',M,y,W-2*M); y-=24
field('Habits and quirks:',M,y,W-2*M); y-=30
head('Medication',y); y-=22
cols=[('Name',M,150),('Dose',M+150,70),('Time(s)',M+220,90),('How given',M+310,110),('If missed',M+420,W-M-(M+420))]
c.setFillColor(DARK); c.setFont('Helvetica-Bold',8.5)
for n,x,w in cols: c.drawString(x+3,y,n)
y-=6; c.setStrokeColor(LINE)
for r in range(6):
    c.line(M,y,W-M,y); y-=22
c.line(M,y,W-M,y)
for n,x,w in cols[1:]: c.line(x,y,x,y+6+22*6) if False else None
y-=22
head('What is normal for my pet',y); y-=26
field('Normal breathing / energy / appetite:',M,y,W-2*M); y-=24
field('Call the vet if:',M,y,W-2*M); y-=30
head('Who to call',y); y-=26
two('Me:','Back-up contact:',y); y-=24
two('My vet:','Vet phone:',y); y-=24
field('Vet address:',M,y,W-2*M); y-=24
two('Out-of-hours vet:','Their phone:',y); y-=24
field('Their address:',M,y,W-2*M); y-=24
two('Insurance company:','Policy number:',y); y-=30
head('Permission',y); y-=24
c.setFillColor(DARK); c.setFont('Helvetica',9)
c.drawString(M,y,'I give my sitter permission to take my pet to a vet if needed, and I will pay the costs. I can be reached on the number above.'); y-=28
field('Signed:',M,y,(W-2*M)/2-10); field('Date:',M+(W-2*M)/2+10,y,(W-2*M)/2-10)
c.setFillColor(LIGHT); c.setFont('CGL',13); c.drawCentredString(W/2,26,'Made with Halo, the pet health app. myhaloapp.co.uk')
c.save(); print('ok')

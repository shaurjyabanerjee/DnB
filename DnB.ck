//        Glitch Drums and Bass Generator 2.0
//                Shaurjya Banerjee
//
//      $$\      $$\$$$$$$$$\$$$$$$\$$$$$$\ $$$$$$$\         
//      $$$\    $$$ \__$$  __\_$$  _\_$$  _|$$  __$$\        
//      $$$$\  $$$$ |  $$ |    $$ |   $$ |  $$ |  $$ |       
//      $$\$$\$$ $$ |  $$ |    $$ |   $$ |  $$ |  $$ |       
//      $$ \$$$  $$ |  $$ |    $$ |   $$ |  $$ |  $$ |       
//      $$ |\$  /$$ |  $$ |    $$ |   $$ |  $$ |  $$ |       
//      $$ | \_/ $$ |  $$ |  $$$$$$\$$$$$$\ $$$$$$$  |       
//      \__|     \__|  \__|  \______\______|\_______/        
//
//   $$\   $$\       $$\      $$$$$$\ $$$$$$$$\ $$$$$$$$\ 
//   $$ |  $$ |      $$ |     \_$$  _|$$  _____|$$  _____|
//   $$ |  $$ |      $$ |       $$ |  $$ |      $$ |      
//   $$$$$$$$ |      $$ |       $$ |  $$$$$\    $$$$$\    
//   \_____$$ |      $$ |       $$ |  $$  __|   $$  __|   
//         $$ |      $$ |       $$ |  $$ |      $$ |      
//         $$ |      $$$$$$$$\$$$$$$\ $$ |      $$$$$$$$\ 
//         \__|      \________\______|\__|      \________|

Pan2 master => dac;
Pan2 drumsBuss => master;
Pan2 fxBuss => LPF filt1 => PRCRev fxRev => master;

SndBuf kik => drumsBuss;
SndBuf snr => Pan2 gatedReverb => drumsBuss;
gatedReverb => PRCRev snrVerb => drumsBuss;

SndBuf hat => drumsBuss;
SndBuf fx => fxBuss;
SndBuf breaks => fxBuss;

0.7 => master.gain;
1 => drumsBuss.gain;

Math.random2f(0.3, 0.6) => snrVerb.mix;
Math.random2f(110, 250) => float BPM;

<<<"Tempo", BPM>>>;

240 / BPM => float whole;
120 / BPM => float half;
(half/2) => float qrtr;
(qrtr/2) => float eight;
(eight*0.6667) => float eightT;
(eight/2) => float sxtn;
(sxtn*0.6667) => float sxtnT;
(sxtn/2) => float thirtytwo;
(thirtytwo * 0.6667) => float thirtytwoT;
(thirtytwo/2) => float sixtyfour;
(sixtyfour*0.6667) => float sixtyfourT;

[ 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0 ] @=> int chakaP1[];
[ 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ] @=> int snrP1[];
[ 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 1, 1, 0, 0 ] @=> int hatP1[];
[ 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 0, 0 ] @=> int kikP1[];
[ 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ] @=> int effects[];

float melt, meltAbs, slowMelt, slowMeltAbs;
4 => int sinewarp;

16 => int seqStep;
16 => int rpt;
int jump, which;

initSamples();
spork ~ filterUpdater();

for (int j; j<1000; j++)
{
    
    for (int i; i<seqStep; i++)
    {
        if (jump == 0)
        {
            Math.random2(0,3) => which;
        }
        
        seq(which, i);
        sxtn::second => now;
        i%4 => jump;
    }
}

fun void kikSampleLoad()
{
    Math.random2(1, 5) => int which;
    
    if (which==1) {me.dir() + "/audio/DrumKit/Kik/1.wav" => kik.read;}
    else if (which==2) {me.dir() + "/audio/DrumKit/Kik/2.wav" => kik.read;}
    else if (which==3) {me.dir() + "/audio/DrumKit/Kik/3.wav" => kik.read;}
    else if (which==4) {me.dir() + "/audio/DrumKit/Kik/4.wav" => kik.read;}
    else if (which==5) {me.dir() + "/audio/DrumKit/Kik/5.wav" => kik.read;}
}
fun void snrSampleLoad()
{
    Math.random2(1, 5) => int which;
    
    if (which==1) {me.dir() + "/audio/DrumKit/Snr/1.wav" => snr.read;}
    else if (which==2) {me.dir() + "/audio/DrumKit/Snr/2.wav" => snr.read;}
    else if (which==3) {me.dir() + "/audio/DrumKit/Snr/3.wav" => snr.read;}
    else if (which==4) {me.dir() + "/audio/DrumKit/Snr/4.wav" => snr.read;}
    else if (which==5) {me.dir() + "/audio/DrumKit/Snr/5.wav" => snr.read;}
}
fun void hatSampleLoad()
{
    Math.random2(1, 5) => int which;
    
    if (which==1) {me.dir() + "/audio/DrumKit/Hat/1.wav" => hat.read;}
    else if (which==2) {me.dir() + "/audio/DrumKit/Hat/2.wav" => hat.read;}
    else if (which==3) {me.dir() + "/audio/DrumKit/Hat/3.wav" => hat.read;}
    else if (which==4) {me.dir() + "/audio/DrumKit/Hat/4.wav" => hat.read;}
    else if (which==5) {me.dir() + "/audio/DrumKit/Hat/5.wav" => hat.read;}
}
fun void fxSampleLoad()
{
    Math.random2(1, 6) => int which;
    
    if (which==1) {me.dir() + "/audio/FX/1.wav" => fx.read;}
    else if (which==2) {me.dir() + "/audio/FX/2.wav" => fx.read;}
    else if (which==3) {me.dir() + "/audio/FX/3.wav" => fx.read;}
    else if (which==4) {me.dir() + "/audio/FX/4.wav" => fx.read;}
    else if (which==5) {me.dir() + "/audio/FX/5.wav" => fx.read;}
    else if (which==6) {me.dir() + "/audio/FX/6.wav" => fx.read;}
}
fun void setPlayheads()
{
    kik.samples() => kik.pos;
    snr.samples() => snr.pos;
    hat.samples() => hat.pos;
}
fun void initSamples()
{
    kikSampleLoad();
    snrSampleLoad();
    hatSampleLoad();
    fxSampleLoad();
    setPlayheads(); 
}
fun void filterUpdater()
{
    while (true)
    {
        2 => filt1.Q;
        100+slowMeltAbs*slowMeltAbs*10000 => filt1.freq;        
        50::ms => now;
    }
}
fun void seq(int which, int pos)
{
    if (sinewarp > 1000) {0 => sinewarp;}
    
    fxSampleLoad();
    int offset;
    if (which==0) {0 => offset;}
    else if (which==1) {4 => offset;}
    else if (which==2) {8 => offset;}
    else if (which==3) {12 => offset;}
    
    if (kikP1[pos%4+offset] == 1) {0 => kik.pos;}
    if (snrP1[pos%4+offset] == 1) {0 => snr.pos;}
    
    if (chakaP1[pos%4+offset] == 1)
    {
        0 => hat.pos;
        meltAbs => hat.rate;
    }
    if (effects[pos] == 1)
    {
        0 => fx.pos;
        meltAbs*2 => fx.rate;
    }
    
    melt => fxBuss.pan;
    (melt/2) => fxRev.mix;
    
    Math.sin(now/1::second*sinewarp*pi) => melt;
    Math.sin(now/1::second*pi*0.1) => slowMelt;
    Math.fabs(melt) => meltAbs;
    Math.fabs(slowMelt) => slowMeltAbs;
    sinewarp++;    
}
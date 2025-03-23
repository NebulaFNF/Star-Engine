package;

#if desktop
import Discord.DiscordClient;
#end
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
#if MODS_ALLOWED
import sys.FileSystem;
import sys.io.File;
#end

using StringTools;

class CreditsState extends MusicBeatState
{
    private var curSelected:Int = -1;
    private var grpOptions:FlxTypedGroup<Alphabet>;
    private var iconArray:Array<AttachedSprite> = [];
    private var creditsData:Array<Array<String>> = [];

    private var bg:FlxSprite;
    private var descText:FlxText;
    private var intendedColor:Int;
    private var colorTween:FlxTween;
    private var descBox:AttachedSprite;

    private var offsetY:Float = -75;
    private var holdTime:Float = 0;
    private var quitting:Bool = false;
    private var moveTween:FlxTween = null;

    override function create()
    {
        #if desktop
        DiscordClient.changePresence("Browsing Credits", null);
        #end

        persistentUpdate = true;
        
        bg = new FlxSprite().loadGraphic(Paths.image('menuDesat'));
        bg.screenCenter();
        add(bg);
        
        grpOptions = new FlxTypedGroup<Alphabet>();
        add(grpOptions);

        populateCredits();
        initializeTextElements();

        bg.color = getCurrentBGColor();
        intendedColor = bg.color;
        changeSelection();

        super.create();
    }

    override function update(elapsed:Float)
    {
        if (FlxG.sound.music.volume < 0.7)
            FlxG.sound.music.volume += 0.5 * elapsed;

        if (!quitting)
        {
            handleInput(elapsed);
            updateTextAlignment(elapsed);
        }

        super.update(elapsed);
    }

private function populateCredits()
{
    var creditsList:Array<Array<String>> = [
        ['Star Engine Team'],
        ['SyncGit12', 'star', 'Lead Developer', 'https://github.com/SyncGit12', '696900'],
        ['Stinko', 'stinkern', 'Debugger & Coder', 'https://stinkernn.carrd.co', '696969'],
        ['Nael2xd', 'nael', 'Programmer', 'https://www.youtube.com/@Nael2xd', '880000'],
        ['lunaruniv69', 'lunaruniv69', 'Lead Developer, Logo Designer', '', 'FF5733'],
        ['moxie-coder', 'moxie-coder', 'Programmer', '', 'C70039'],
        ['mcagabe19', 'mcagabe19', 'Mobile Port Developer, Programmer', '', '900C3F'],
        ['cyklusiguess', 'cyklusiguess', 'Developer', '', '581845'],
        ['HRK_EXEX', 'hrk', 'Developer, FPS Counter Creator, Rendering Mode Creator', 'https://www.youtube.com/@HRK_EXEX/featured', '01F8FF'],
        ['TheStinkern', 'thestinkern', 'Small coder, debugger', '', '6A0DAD'],
        
        ['Special Thanks'],
        ['Stefan2008', 'stefan', 'Main Menu Tips Contributor', 'https://www.youtube.com/@stefan2008official', '8B4513']
    ];
    
    for (entry in creditsList)
        creditsData.push(entry);

    for (i in 0...creditsData.length)
    {
        var selectable:Bool = !isUnselectable(i);
        var optionText:Alphabet = new Alphabet(FlxG.width / 2, 300, creditsData[i][0], !selectable);
        optionText.isMenuItem = true;
        optionText.targetY = i;
        optionText.changeX = false;
        optionText.snapToPosition();
        grpOptions.add(optionText);

        if (selectable)
        {
            var icon:AttachedSprite = new AttachedSprite('credits/' + creditsData[i][1]);
            icon.xAdd = optionText.width + 10;
            icon.sprTracker = optionText;
            iconArray.push(icon);
            add(icon);
            if (curSelected == -1) curSelected = i;
        }
        else
        {
            optionText.alignment = CENTERED;
        }
    }
}


    private function initializeTextElements()
    {
        descBox = new AttachedSprite();
        descBox.makeGraphic(1, 1, FlxColor.BLACK);
        descBox.alphaMult = 0.6;
        descBox.alpha = 0.6;
        add(descBox);

        descText = new FlxText(50, FlxG.height + offsetY - 25, 1180, "", 32);
        descText.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, CENTER);
        descText.scrollFactor.set();
        descBox.sprTracker = descText;
        add(descText);
    }

    private function handleInput(elapsed:Float)
    {
        var shiftMult:Int = (FlxG.keys.pressed.SHIFT) ? 3 : 1;
        var upPressed = controls.UI_UP_P;
        var downPressed = controls.UI_DOWN_P;

        if (upPressed) changeSelection(-shiftMult);
        if (downPressed) changeSelection(shiftMult);

        if (controls.UI_DOWN || controls.UI_UP)
        {
            var prevHoldTime:Int = Math.floor((holdTime - 0.5) * 10);
            holdTime += elapsed;
            var newHoldTime:Int = Math.floor((holdTime - 0.5) * 10);

            if (holdTime > 0.5 && newHoldTime > prevHoldTime)
                changeSelection((newHoldTime - prevHoldTime) * (controls.UI_UP ? -shiftMult : shiftMult));
        }

        if (controls.ACCEPT && creditsData[curSelected][3] != null)
            CoolUtil.browserLoad(creditsData[curSelected][3]);

        if (controls.BACK)
        {
            if (colorTween != null) colorTween.cancel();
            FlxG.sound.play(Paths.sound('cancelMenu'));
            MusicBeatState.switchState(new MainMenuState());
            quitting = true;
        }
    }

    private function updateTextAlignment(elapsed:Float)
    {
        for (item in grpOptions.members)
        {
            var lerpFactor:Float = CoolUtil.boundTo(elapsed * 12, 0, 1);
            item.x = (item.targetY == 0) ? FlxMath.lerp(item.x, FlxG.width / 2 - 70, lerpFactor) : FlxMath.lerp(item.x, 200 + -40 * Math.abs(item.targetY), lerpFactor);
        }
    }

    private function changeSelection(change:Int = 0)
    {
        do {
            curSelected += change;
            if (curSelected < 0) curSelected = creditsData.length - 1;
            if (curSelected >= creditsData.length) curSelected = 0;
        } while (isUnselectable(curSelected));

        descText.text = creditsData[curSelected][2];
        descText.y = FlxG.height - descText.height + offsetY - 60;

        if (moveTween != null) moveTween.cancel();
        moveTween = FlxTween.tween(descText, {y: descText.y + 75}, 0.25, {ease: FlxEase.sineOut});
    }

    private function getCurrentBGColor():Int
    {
        return Std.parseInt("0xFF" + creditsData[curSelected][4]);
    }

    private function isUnselectable(index:Int):Bool
    {
        return creditsData[index].length <= 1;
    }
}

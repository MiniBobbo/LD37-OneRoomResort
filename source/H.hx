package;
import defs.EmotDef;
import defs.LevelDef;
import types.ActivityTypes;

/**
 * ...
 * @author Dave
 */
class H
{

	//This is a hacky way around the substate being closed problem.
	public static var subStateClosed:Bool = false;
	
	public static var levels:Array<defs.LevelDef>;
	public static var emotions:Array<EmotDef>;
	
	//A list of all the guests that should be kicked next update loop.
	public static var kickGuests:Array<Guest>;
	
	/**
	 * Puts this guest in the queue to have an emotion spawn this turn.
	 * @param	guest
	 */
	public static function spawnEmotion(guest:Guest, emot:String = '') {
		emotions.push( { 
			guest:guest,
			emot:emot});
	}
	
	public static function kickGuest(guest:Guest) {
		kickGuests.push(guest);
	}
	
	/**
	 * Inits the static variables.
	 */
	public static function init() {
		levels = [];
		emotions = [];
		kickGuests = [];
		
		levels.push( {
			levelNum:1,
			name:'Starting Out',
			guests:3,
			activities:['room', 'pool', 'spa'],
			gameLength:45,
			
			startTo:'activities@oneroomresort.com',
			startFrom:'TheBossMan@oneroomresort.com',
			startSubject:'Welcome on board!',
			startEmail:"Heeeeeyyy Susan!\n\nI'm so glad you decided to join our team here at One Room Resort, where every guest gets a room.  I am confident that you will do a great job as activities coordinator keeping all our guests entertained for the duration of their stay!\n\nWe are going to start off on a slow week.  Only a few guests and activities that need to be planned for the week.  Think of this as a chance to get your feet wet!  Remember, guests don't like to do the same activity for too long, so be sure to give them a variety of activites to do!  Plus, our guests sometimes are having so much fun that they fall asleep with whatever they are doing.  This makes them cranky, so make sure to get them to bed before they run out of energy!\n\nLooking forward to working with you!!!\nChad 'The Boss' Huntington",
			endTo:'TheBossMan@oneroomresort.com',
			endFrom:'activities@oneroomresort.com',
			endSubject:'re: Welcome on board!',
			endEmail:"Hi Chad,\nI'm excited for this opportunity.  I have been trying to get in touch with you all week but I wasn't able to get you on the phone.  Things have been a little crazy this week.  I could only find a single room for the guests to stay in.  I shifted everyone around and made sure that only one person was sleeping at a time and got by, but I would appreciate knowing where all the other rooms are before next week's guests arrive!\n\nSusan, Activities Coordinator"
			
		});
		
		levels.push( {
						levelNum:2,
			name:'Tennis Trouble',
			guests:5,
			activities:['room', 'pool', 'spa', 'tennis'],
			gameLength:60,
			
			startTo:'TheBossMan@oneroomresort.com',
			startFrom:'activities@oneroomresort.com',
			startSubject:'Still only one room',
			startEmail:"Hi Chad,\n\nCan you please call me or get in touch with me?  I showed up to work this week and I still can't find any more rooms.  I appreciate you building us a tennis court, but I can't help but think that a better use of the funds would be to build additional rooms that our guests can sleep in.  Am I just missing something?  Are there rooms elsewhere on the property that I'm just not aware of?  I'm not sure how many more guests I can juggle with only a single room.\n\nSusan, Activities Coordinator",
			endTo:'activities@oneroomresort.com',
			endFrom:'TheBossMan@oneroomresort.com',
			endSubject:'Automatic Reply: Still only one room',
			endEmail:"Greetings [Insert name of email recipient here]!\n\n I'm sorry to say (but not too sorry!! ;)  that I will be out of the office for the next week.  I will be attending a hospitality conference in lovely H-A-W-A-I-I!!!  Am I lucky or what?\n\nI will be responding to emails as I'm able, but these things can get pretty off the hook (if you know what I mean!) so it may be next week before I can get back to you.\n\nStay cool!\nChad 'The Boss' Huntington"
		});
		
		levels.push( {
						levelNum:3,
			name:'Spa-la-la',
			guests:7,
			activities:['room', 'pool', 'spa', 'tennis', 'spa'],
			gameLength:60,
			
			startTo:'TheBossMan@oneroomresort.com',
			startFrom:'activities@oneroomresort.com',
			startSubject:'Another spa?  Seriously?',
			startEmail:"Chad,\n\nThis is getting ridiculous.  How do you expect me to keep everyone entertained when there is only a single room for sleeping?  I'm going to have people falling asleep all over the place!\n\nSusan, Activities Coordinator",
			endTo:'activities@oneroomresort.com',
			endFrom:'TheBossMan@oneroomresort.com',
			endSubject:'Automatic Reply: Still only one room',
			endEmail:"Hi Susan!\nThanks for all your wonderful emails.  I have to confess that I only skimmed them briefly, but I really think that your suggestions are great!!  I'll be sure to take them into consideration!!\n\nBy the way, we should have a big party coming next week.  I've ordered some additional activities for you to keep our guests entertained with.  Keep up the great work!\n\nChad 'The Boss' Huntington"
		});

		levels.push( {
						levelNum:4,
			name:'Party of 9',
			guests:9,
			activities:['room', 'pool', 'pool', 'spa', 'tennis', 'spa', 'tennis', 'spa'],
			gameLength:90,
			
			startTo:'TheBossMan@oneroomresort.com',
			startFrom:'activities@oneroomresort.com',
			startSubject:'re: Another spa?  Seriously?',
			startEmail:"Chad,\n\nI don't think you are really reading my emails.  This is getting worse and worse every week.  How do you expect me to keep almost 10 people entertained when they are all falling over from exhaustion?  This must be some sort of health code violation or something.\nI'm not normaly a quitter, but if this situation isn't rectified by the end of the week I'm afraid that you will have to find a new activities coordinator.\n\nSusan, Activities Coordinator",
			endTo:'activities@oneroomresort.com',
			endFrom:'TheBossMan@oneroomresort.com',
			endSubject:'re: Another spa?  Seriously?',
			endEmail:"Hi Susan!\nI'm noticing a little frustration in your last email.  I feel like we haven't been communicating well, so I've taken the liberty of signing you up for a wonderful class my brother teaches called 'Communicating in the Workplace' because, just between the two of us, communication isn't your strong point.  Don't worry though!  We all have areas we can improve!!\n\nJust to make sure I address your concerns I re-read your email very carefully.  I love your idea of adding anther spa!!!  I'll call the contractors.\n\nChad 'The Boss' Huntington"
		});

		levels.push( {
			levelNum:5,
			name:'Pushy Guests',
			guests:5,
			activities:['room', 'pool', 'spa', 'tennis', 'spa'],
			gameLength:90,
			
			wantBaseTime:5,
			wantVariableTime:10,
			wantList:[ActivityTypes.relaxation, ActivityTypes.exercise],
			wantGuestTimeLimit:5,
			
			startTo:'activities@oneroomresort.com',
			startFrom:'TheBossMan@oneroomresort.com',
			startSubject:'VIPs coming this week!',
			startEmail:"Hey Susan!!!,\n\nI just wanted to drop a note to say thanks for what a great job you are doing!  Last week was a little crazy, huh?  All those guests!  Wow!  The great news is that THIS week will be much easier.  Only a few guests.  I've taken some of the activity areas down for maintenance, but I'm sure you will find stuff for everyone to do!\n\nI probably should mention that this week we have some particularly picky guests coming.  Don't be surprised if they make requests for different activities.  Meeting a guest's wants give them a happiness and energy boost, so be sure to get to them as soon as possible.  There are other benefits to meeting the wants of the guests.  For instance, the intense feeling of satisfaction you get for a job well done.  \n\nDo your best to accomodate them!\n\nChad 'The Boss' Huntington",
			endTo:'activities@oneroomresort.com',
			endFrom:'HR@competingresorts.com',
			endSubject:'Your Inquiry',
			endEmail:"Hi Susan,\nThanks for your interest in a job at Competing Resorts!  I am just writing to let you know that we received your resume and will be reviewing it shortly.  Someone should be reaching out to you in the next week or two to set up an interview.  \n\nHarold Finch\nHR Representative\nCompetingResorts.com"
		});
		levels.push( {
			name:'Coffeehouse Blues',
			guests:5,
			activities:['room', 'pool', 'spa', 'tennis', 'coffee', 'potty'],
			gameLength:90,
			
			wantBaseTime:10,
			wantVariableTime:10,
			wantList:[ActivityTypes.relaxation, ActivityTypes.exercise],
			wantGuestTimeLimit:5,
			
			startTo:'activities@oneroomresort.com',
			startFrom:'TheBossMan@oneroomresort.com',
			startSubject:'Sleepy guests',
			startEmail:"Hey Susan!!!,\n\nRead your past updates!  Awesome stuff!  Keep up the good work!\n\nI noticed the theme of sleepy guests coming up repeatedly in your reoprts.  Very astute!  I knew when I hired you that you would really dial into the guests feelings and desires!  You haven't disappointed me yet!\n\nI came up with a solution to the sleeping guests problem.  Obviously we need more...\n\nCoffee Bars!!  Coffee will give the guests a jolt of energy and happiness.  Just make sure that they get to the bathroom in a timely manner!!\n\nChad 'The Boss' Huntington",
			endTo:'TheBossMan@oneroomresort.com',
			endFrom:'activities@oneroomresort.com',
			endSubject:'re: Sleepy guests',
			endEmail:"Chad,\nYou just aren't getting this.  The guests are falling asleep because we only have a single room for them to rest in.  I'm not sure how you aren't understanding this.  I personally would HATE coming to your resort!  \n\n\nSusan"
		});
		
		for (i in 0...levels.length) 
			levels[i].levelNum = i;

	}
	
}
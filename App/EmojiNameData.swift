import Foundation

// v0.34i: generated from CLDR (the official Unicode names) —
// one line per emoji: emoji <TAB> nombre ES <TAB> name EN.
// Spanish names exist for the common emojis; English covers all.
enum EmojiNameData {
    static let all: [(emoji: String, es: String, en: String)] = {
        emojiNameRaw.split(separator: "\n").map { line in
            let p = line.split(separator: "\t", omittingEmptySubsequences: false)
            return (String(p[0]),
                    p.count > 1 ? String(p[1]) : "",
                    p.count > 2 ? String(p[2]) : "")
        }
    }()
}
private let emojiNameRaw = """
😀	cara sonriendo	grinning face
😃	cara sonriendo con ojos grandes	grinning face with big eyes
😄	cara sonriendo con ojos sonrientes	grinning face with smiling eyes
😁	cara radiante con ojos sonrientes	beaming face with smiling eyes
😆	cara sonriendo con los ojos cerrados	grinning squinting face
😅	cara sonriendo con sudor frío	grinning face with sweat
🤣	cara revolviéndose de la risa	rolling on the floor laughing
😂	cara llorando de risa	face with tears of joy
🙂	cara sonriendo ligeramente	slightly smiling face
🙃	cara al revés	upside-down face
🫠	cara derritiéndose	melting face
😉	cara guiñando el ojo	winking face
😊	cara feliz con ojos sonrientes	smiling face with smiling eyes
😇	cara sonriendo con aureola	smiling face with halo
🥰	cara sonriendo con corazones	smiling face with hearts
😍	cara sonriendo con ojos de corazón	smiling face with heart-eyes
🤩	cara sonriendo con estrellas	star-struck
😘	cara lanzando un beso	face blowing a kiss
😗	cara besando	kissing face
☺️		smiling face
😚	cara besando con los ojos cerrados	kissing face with closed eyes
😙	cara besando con ojos sonrientes	kissing face with smiling eyes
🥲	cara sonriente con lágrima	smiling face with tear
😋	cara saboreando comida	face savoring food
😛	cara sacando la lengua	face with tongue
😜	cara sacando la lengua y guiñando un ojo	winking face with tongue
🤪	cara de loco	zany face
😝	cara con ojos cerrados y lengua fuera	squinting face with tongue
🤑	cara con lengua de dinero	money-mouth face
🤗	cara con manos abrazando	smiling face with open hands
🤭	cara con mano sobre la boca	face with hand over mouth
🫢	cara con ojos abiertos y boca tapada	face with open eyes and hand over mouth
🫣	cara tapada con ojo espiando	face with peeking eye
🤫	cara pidiendo silencio	shushing face
🤔	cara pensativa	thinking face
🫡	cara saludando	saluting face
🤐	cara con la boca cerrada con cremallera	zipper-mouth face
🤨	cara con ceja alzada	face with raised eyebrow
😐	cara neutral	neutral face
😑	cara sin expresión	expressionless face
😶	cara sin boca	face without mouth
🫥	cara con línea de puntos	dotted line face
😶‍🌫️		face in clouds
😏	cara sonriendo con superioridad	smirking face
😒	cara de desaprobación	unamused face
🙄	cara con ojos en blanco	face with rolling eyes
😬	cara haciendo una mueca	grimacing face
😮‍💨	cara exhalando	face exhaling
🤥	cara de mentiroso	lying face
🫨	cara temblorosa	shaking face
🙂‍↔️		head shaking horizontally
🙂‍↕️		head shaking vertically
😌	cara de alivio	relieved face
😔	cara desanimada	pensive face
😪	cara de sueño	sleepy face
🤤	cara babeando	drooling face
😴	cara durmiendo	sleeping face
😷	cara con mascarilla médica	face with medical mask
🤒	cara con termómetro	face with thermometer
🤕	cara con la cabeza vendada	face with head-bandage
🤢	cara de náuseas	nauseated face
🤮	cara vomitando	face vomiting
🤧	cara estornudando	sneezing face
🥵	cara con calor	hot face
🥶	cara con frío	cold face
🥴	cara de grogui	woozy face
😵	cara mareada	face with crossed-out eyes
😵‍💫	cara con ojos en espiral	face with spiral eyes
🤯	cabeza explotando	exploding head
🤠	cara con sombrero de vaquero	cowboy hat face
🥳	cara de fiesta	partying face
🥸	cara disfrazada	disguised face
😎	cara sonriendo con gafas de sol	smiling face with sunglasses
🤓	cara de empollón	nerd face
🧐	cara con monóculo	face with monocle
😕	cara de confusión	confused face
🫤	cara con boca diagonal	face with diagonal mouth
😟	cara preocupada	worried face
🙁	cara con el ceño ligeramente fruncido	slightly frowning face
☹️		frowning face
😮	cara con la boca abierta	face with open mouth
😯	cara estupefacta	hushed face
😲	cara asombrada	astonished face
😳	cara sonrojada	flushed face
🥺	cara suplicante	pleading face
🥹	cara aguantándose las lágrimas	face holding back tears
😦	cara con el ceño fruncido y la boca abierta	frowning face with open mouth
😧	cara angustiada	anguished face
😨	cara asustada	fearful face
😰	cara con ansiedad y sudor	anxious face with sweat
😥	cara triste pero aliviada	sad but relieved face
😢	cara llorando	crying face
😭	cara llorando fuerte	loudly crying face
😱	cara gritando de miedo	face screaming in fear
😖	cara de frustración	confounded face
😣	cara desesperada	persevering face
😞	cara decepcionada	disappointed face
😓	cara con sudor frío	downcast face with sweat
😩	cara agotada	weary face
😫	cara cansada	tired face
🥱	cara de bostezo	yawning face
😤	cara resoplando	face with steam from nose
😡	cara cabreada	enraged face
😠	cara enfadada	angry face
🤬	cara con símbolos en la boca	face with symbols on mouth
😈	cara sonriendo con cuernos	smiling face with horns
👿	cara enfadada con cuernos	angry face with horns
💀	calavera	skull
☠️		skull and crossbones
💩	caca con ojos	pile of poo
🤡	cara de payaso	clown face
👹	demonio japonés oni	ogre
👺	demonio japonés tengu	goblin
👻	fantasma	ghost
👽	alienígena	alien
👾	monstruo alienígena	alien monster
🤖	robot	robot
😺	gato sonriendo	grinning cat
😸	gato sonriendo con ojos sonrientes	grinning cat with smiling eyes
😹	gato llorando de risa	cat with tears of joy
😻	gato sonriendo con ojos de corazón	smiling cat with heart-eyes
😼	gato haciendo una mueca	cat with wry smile
😽	gato besando	kissing cat
🙀	gato asustado	weary cat
😿	gato llorando	crying cat
😾	gato enfadado	pouting cat
🙈	mono con los ojos tapados	see-no-evil monkey
🙉	mono con los oídos tapados	hear-no-evil monkey
🙊	mono con la boca tapada	speak-no-evil monkey
💌	carta de amor	love letter
💘	corazón con flecha	heart with arrow
💝	corazón con lazo	heart with ribbon
💖	corazón brillante	sparkling heart
💗	corazón creciente	growing heart
💓	corazón latiendo	beating heart
💞	corazones giratorios	revolving hearts
💕	dos corazones	two hearts
💟	adorno de corazón	heart decoration
❣️		heart exclamation
💔	corazón roto	broken heart
❤️‍🔥		heart on fire
❤️‍🩹		mending heart
❤️		red heart
🩷	corazón rosa	pink heart
🧡	corazón naranja	orange heart
💛	corazón amarillo	yellow heart
💚	corazón verde	green heart
💙	corazón azul	blue heart
🩵	corazón azul claro	light blue heart
💜	corazón morado	purple heart
🤎	corazón marrón	brown heart
🖤	corazón negro	black heart
🩶	corazón gris	grey heart
🤍	corazón blanco	white heart
💋	marca de beso	kiss mark
💯	cien puntos	hundred points
💢	símbolo de enfado	anger symbol
💥	colisión	collision
💫	símbolo de mareo	dizzy
💦	gotas de sudor	sweat droplets
💨	salir corriendo	dashing away
🕳️		hole
💬	bocadillo de diálogo	speech balloon
👁️‍🗨️		eye in speech bubble
🗨️		left speech bubble
🗯️		right anger bubble
💭	bocadillo de pensamiento	thought balloon
💤	símbolo de sueño	ZZZ
👋	mano saludando	waving hand
👋🏻		waving hand: light skin tone
👋🏼		waving hand: medium-light skin tone
👋🏽		waving hand: medium skin tone
👋🏾		waving hand: medium-dark skin tone
👋🏿		waving hand: dark skin tone
🤚	dorso de la mano	raised back of hand
🤚🏻		raised back of hand: light skin tone
🤚🏼		raised back of hand: medium-light skin tone
🤚🏽		raised back of hand: medium skin tone
🤚🏾		raised back of hand: medium-dark skin tone
🤚🏿		raised back of hand: dark skin tone
🖐️		hand with fingers splayed
🖐🏻		hand with fingers splayed: light skin tone
🖐🏼		hand with fingers splayed: medium-light skin tone
🖐🏽		hand with fingers splayed: medium skin tone
🖐🏾		hand with fingers splayed: medium-dark skin tone
🖐🏿		hand with fingers splayed: dark skin tone
✋	mano levantada	raised hand
✋🏻		raised hand: light skin tone
✋🏼		raised hand: medium-light skin tone
✋🏽		raised hand: medium skin tone
✋🏾		raised hand: medium-dark skin tone
✋🏿		raised hand: dark skin tone
🖖	saludo vulcano	vulcan salute
🖖🏻		vulcan salute: light skin tone
🖖🏼		vulcan salute: medium-light skin tone
🖖🏽		vulcan salute: medium skin tone
🖖🏾		vulcan salute: medium-dark skin tone
🖖🏿		vulcan salute: dark skin tone
🫱	mano hacia la derecha	rightwards hand
🫱🏻		rightwards hand: light skin tone
🫱🏼		rightwards hand: medium-light skin tone
🫱🏽		rightwards hand: medium skin tone
🫱🏾		rightwards hand: medium-dark skin tone
🫱🏿		rightwards hand: dark skin tone
🫲	mano hacia la izquierda	leftwards hand
🫲🏻		leftwards hand: light skin tone
🫲🏼		leftwards hand: medium-light skin tone
🫲🏽		leftwards hand: medium skin tone
🫲🏾		leftwards hand: medium-dark skin tone
🫲🏿		leftwards hand: dark skin tone
🫳	mano con la palma hacia abajo	palm down hand
🫳🏻		palm down hand: light skin tone
🫳🏼		palm down hand: medium-light skin tone
🫳🏽		palm down hand: medium skin tone
🫳🏾		palm down hand: medium-dark skin tone
🫳🏿		palm down hand: dark skin tone
🫴	mano con la palma hacia arriba	palm up hand
🫴🏻		palm up hand: light skin tone
🫴🏼		palm up hand: medium-light skin tone
🫴🏽		palm up hand: medium skin tone
🫴🏾		palm up hand: medium-dark skin tone
🫴🏿		palm up hand: dark skin tone
🫷	mano empujando hacia la izquierda	leftwards pushing hand
🫷🏻		leftwards pushing hand: light skin tone
🫷🏼		leftwards pushing hand: medium-light skin tone
🫷🏽		leftwards pushing hand: medium skin tone
🫷🏾		leftwards pushing hand: medium-dark skin tone
🫷🏿		leftwards pushing hand: dark skin tone
🫸	mano empujando hacia la derecha	rightwards pushing hand
🫸🏻		rightwards pushing hand: light skin tone
🫸🏼		rightwards pushing hand: medium-light skin tone
🫸🏽		rightwards pushing hand: medium skin tone
🫸🏾		rightwards pushing hand: medium-dark skin tone
🫸🏿		rightwards pushing hand: dark skin tone
👌	señal de aprobación con la mano	OK hand
👌🏻		OK hand: light skin tone
👌🏼		OK hand: medium-light skin tone
👌🏽		OK hand: medium skin tone
👌🏾		OK hand: medium-dark skin tone
👌🏿		OK hand: dark skin tone
🤌	dedos juntos apuntando hacia arriba	pinched fingers
🤌🏻		pinched fingers: light skin tone
🤌🏼		pinched fingers: medium-light skin tone
🤌🏽		pinched fingers: medium skin tone
🤌🏾		pinched fingers: medium-dark skin tone
🤌🏿		pinched fingers: dark skin tone
🤏	mano pellizcando	pinching hand
🤏🏻		pinching hand: light skin tone
🤏🏼		pinching hand: medium-light skin tone
🤏🏽		pinching hand: medium skin tone
🤏🏾		pinching hand: medium-dark skin tone
🤏🏿		pinching hand: dark skin tone
✌️		victory hand
✌🏻		victory hand: light skin tone
✌🏼		victory hand: medium-light skin tone
✌🏽		victory hand: medium skin tone
✌🏾		victory hand: medium-dark skin tone
✌🏿		victory hand: dark skin tone
🤞	dedos cruzados	crossed fingers
🤞🏻		crossed fingers: light skin tone
🤞🏼		crossed fingers: medium-light skin tone
🤞🏽		crossed fingers: medium skin tone
🤞🏾		crossed fingers: medium-dark skin tone
🤞🏿		crossed fingers: dark skin tone
🫰	mano con dedo índice y pulgar cruzados	hand with index finger and thumb crossed
🫰🏻		hand with index finger and thumb crossed: light skin tone
🫰🏼		hand with index finger and thumb crossed: medium-light skin tone
🫰🏽		hand with index finger and thumb crossed: medium skin tone
🫰🏾		hand with index finger and thumb crossed: medium-dark skin tone
🫰🏿		hand with index finger and thumb crossed: dark skin tone
🤟	gesto de te quiero	love-you gesture
🤟🏻		love-you gesture: light skin tone
🤟🏼		love-you gesture: medium-light skin tone
🤟🏽		love-you gesture: medium skin tone
🤟🏾		love-you gesture: medium-dark skin tone
🤟🏿		love-you gesture: dark skin tone
🤘	mano haciendo el signo de cuernos	sign of the horns
🤘🏻		sign of the horns: light skin tone
🤘🏼		sign of the horns: medium-light skin tone
🤘🏽		sign of the horns: medium skin tone
🤘🏾		sign of the horns: medium-dark skin tone
🤘🏿		sign of the horns: dark skin tone
🤙	mano haciendo el gesto de llamar	call me hand
🤙🏻		call me hand: light skin tone
🤙🏼		call me hand: medium-light skin tone
🤙🏽		call me hand: medium skin tone
🤙🏾		call me hand: medium-dark skin tone
🤙🏿		call me hand: dark skin tone
👈	dorso de mano con índice a la izquierda	backhand index pointing left
👈🏻		backhand index pointing left: light skin tone
👈🏼		backhand index pointing left: medium-light skin tone
👈🏽		backhand index pointing left: medium skin tone
👈🏾		backhand index pointing left: medium-dark skin tone
👈🏿		backhand index pointing left: dark skin tone
👉	dorso de mano con índice a la derecha	backhand index pointing right
👉🏻		backhand index pointing right: light skin tone
👉🏼		backhand index pointing right: medium-light skin tone
👉🏽		backhand index pointing right: medium skin tone
👉🏾		backhand index pointing right: medium-dark skin tone
👉🏿		backhand index pointing right: dark skin tone
👆	dorso de mano con índice hacia arriba	backhand index pointing up
👆🏻		backhand index pointing up: light skin tone
👆🏼		backhand index pointing up: medium-light skin tone
👆🏽		backhand index pointing up: medium skin tone
👆🏾		backhand index pointing up: medium-dark skin tone
👆🏿		backhand index pointing up: dark skin tone
🖕	dedo corazón hacia arriba	middle finger
🖕🏻		middle finger: light skin tone
🖕🏼		middle finger: medium-light skin tone
🖕🏽		middle finger: medium skin tone
🖕🏾		middle finger: medium-dark skin tone
🖕🏿		middle finger: dark skin tone
👇	dorso de mano con índice hacia abajo	backhand index pointing down
👇🏻		backhand index pointing down: light skin tone
👇🏼		backhand index pointing down: medium-light skin tone
👇🏽		backhand index pointing down: medium skin tone
👇🏾		backhand index pointing down: medium-dark skin tone
👇🏿		backhand index pointing down: dark skin tone
☝️		index pointing up
☝🏻		index pointing up: light skin tone
☝🏼		index pointing up: medium-light skin tone
☝🏽		index pointing up: medium skin tone
☝🏾		index pointing up: medium-dark skin tone
☝🏿		index pointing up: dark skin tone
🫵	dedo índice apuntándote a ti	index pointing at the viewer
🫵🏻		index pointing at the viewer: light skin tone
🫵🏼		index pointing at the viewer: medium-light skin tone
🫵🏽		index pointing at the viewer: medium skin tone
🫵🏾		index pointing at the viewer: medium-dark skin tone
🫵🏿		index pointing at the viewer: dark skin tone
👍	pulgar hacia arriba	thumbs up
👍🏻		thumbs up: light skin tone
👍🏼		thumbs up: medium-light skin tone
👍🏽		thumbs up: medium skin tone
👍🏾		thumbs up: medium-dark skin tone
👍🏿		thumbs up: dark skin tone
👎	pulgar hacia abajo	thumbs down
👎🏻		thumbs down: light skin tone
👎🏼		thumbs down: medium-light skin tone
👎🏽		thumbs down: medium skin tone
👎🏾		thumbs down: medium-dark skin tone
👎🏿		thumbs down: dark skin tone
✊	puño en alto	raised fist
✊🏻		raised fist: light skin tone
✊🏼		raised fist: medium-light skin tone
✊🏽		raised fist: medium skin tone
✊🏾		raised fist: medium-dark skin tone
✊🏿		raised fist: dark skin tone
👊	puño cerrado	oncoming fist
👊🏻		oncoming fist: light skin tone
👊🏼		oncoming fist: medium-light skin tone
👊🏽		oncoming fist: medium skin tone
👊🏾		oncoming fist: medium-dark skin tone
👊🏿		oncoming fist: dark skin tone
🤛	puño hacia la izquierda	left-facing fist
🤛🏻		left-facing fist: light skin tone
🤛🏼		left-facing fist: medium-light skin tone
🤛🏽		left-facing fist: medium skin tone
🤛🏾		left-facing fist: medium-dark skin tone
🤛🏿		left-facing fist: dark skin tone
🤜	puño hacia la derecha	right-facing fist
🤜🏻		right-facing fist: light skin tone
🤜🏼		right-facing fist: medium-light skin tone
🤜🏽		right-facing fist: medium skin tone
🤜🏾		right-facing fist: medium-dark skin tone
🤜🏿		right-facing fist: dark skin tone
👏	manos aplaudiendo	clapping hands
👏🏻		clapping hands: light skin tone
👏🏼		clapping hands: medium-light skin tone
👏🏽		clapping hands: medium skin tone
👏🏾		clapping hands: medium-dark skin tone
👏🏿		clapping hands: dark skin tone
🙌	manos levantadas celebrando	raising hands
🙌🏻		raising hands: light skin tone
🙌🏼		raising hands: medium-light skin tone
🙌🏽		raising hands: medium skin tone
🙌🏾		raising hands: medium-dark skin tone
🙌🏿		raising hands: dark skin tone
🫶	manos formando un corazón	heart hands
🫶🏻		heart hands: light skin tone
🫶🏼		heart hands: medium-light skin tone
🫶🏽		heart hands: medium skin tone
🫶🏾		heart hands: medium-dark skin tone
🫶🏿		heart hands: dark skin tone
👐	manos abiertas	open hands
👐🏻		open hands: light skin tone
👐🏼		open hands: medium-light skin tone
👐🏽		open hands: medium skin tone
👐🏾		open hands: medium-dark skin tone
👐🏿		open hands: dark skin tone
🤲	palmas hacia arriba juntas	palms up together
🤲🏻		palms up together: light skin tone
🤲🏼		palms up together: medium-light skin tone
🤲🏽		palms up together: medium skin tone
🤲🏾		palms up together: medium-dark skin tone
🤲🏿		palms up together: dark skin tone
🤝	apretón de manos	handshake
🤝🏻		handshake: light skin tone
🤝🏼		handshake: medium-light skin tone
🤝🏽		handshake: medium skin tone
🤝🏾		handshake: medium-dark skin tone
🤝🏿		handshake: dark skin tone
🫱🏻‍🫲🏼		handshake: light skin tone, medium-light skin tone
🫱🏻‍🫲🏽		handshake: light skin tone, medium skin tone
🫱🏻‍🫲🏾		handshake: light skin tone, medium-dark skin tone
🫱🏻‍🫲🏿		handshake: light skin tone, dark skin tone
🫱🏼‍🫲🏻		handshake: medium-light skin tone, light skin tone
🫱🏼‍🫲🏽		handshake: medium-light skin tone, medium skin tone
🫱🏼‍🫲🏾		handshake: medium-light skin tone, medium-dark skin tone
🫱🏼‍🫲🏿		handshake: medium-light skin tone, dark skin tone
🫱🏽‍🫲🏻		handshake: medium skin tone, light skin tone
🫱🏽‍🫲🏼		handshake: medium skin tone, medium-light skin tone
🫱🏽‍🫲🏾		handshake: medium skin tone, medium-dark skin tone
🫱🏽‍🫲🏿		handshake: medium skin tone, dark skin tone
🫱🏾‍🫲🏻		handshake: medium-dark skin tone, light skin tone
🫱🏾‍🫲🏼		handshake: medium-dark skin tone, medium-light skin tone
🫱🏾‍🫲🏽		handshake: medium-dark skin tone, medium skin tone
🫱🏾‍🫲🏿		handshake: medium-dark skin tone, dark skin tone
🫱🏿‍🫲🏻		handshake: dark skin tone, light skin tone
🫱🏿‍🫲🏼		handshake: dark skin tone, medium-light skin tone
🫱🏿‍🫲🏽		handshake: dark skin tone, medium skin tone
🫱🏿‍🫲🏾		handshake: dark skin tone, medium-dark skin tone
🙏	manos en oración	folded hands
🙏🏻		folded hands: light skin tone
🙏🏼		folded hands: medium-light skin tone
🙏🏽		folded hands: medium skin tone
🙏🏾		folded hands: medium-dark skin tone
🙏🏿		folded hands: dark skin tone
✍️		writing hand
✍🏻		writing hand: light skin tone
✍🏼		writing hand: medium-light skin tone
✍🏽		writing hand: medium skin tone
✍🏾		writing hand: medium-dark skin tone
✍🏿		writing hand: dark skin tone
💅	pintarse las uñas	nail polish
💅🏻		nail polish: light skin tone
💅🏼		nail polish: medium-light skin tone
💅🏽		nail polish: medium skin tone
💅🏾		nail polish: medium-dark skin tone
💅🏿		nail polish: dark skin tone
🤳	selfi	selfie
🤳🏻		selfie: light skin tone
🤳🏼		selfie: medium-light skin tone
🤳🏽		selfie: medium skin tone
🤳🏾		selfie: medium-dark skin tone
🤳🏿		selfie: dark skin tone
💪	bíceps flexionado	flexed biceps
💪🏻		flexed biceps: light skin tone
💪🏼		flexed biceps: medium-light skin tone
💪🏽		flexed biceps: medium skin tone
💪🏾		flexed biceps: medium-dark skin tone
💪🏿		flexed biceps: dark skin tone
🦾	brazo mecánico	mechanical arm
🦿	pierna mecánica	mechanical leg
🦵	pierna	leg
🦵🏻		leg: light skin tone
🦵🏼		leg: medium-light skin tone
🦵🏽		leg: medium skin tone
🦵🏾		leg: medium-dark skin tone
🦵🏿		leg: dark skin tone
🦶	pie	foot
🦶🏻		foot: light skin tone
🦶🏼		foot: medium-light skin tone
🦶🏽		foot: medium skin tone
🦶🏾		foot: medium-dark skin tone
🦶🏿		foot: dark skin tone
👂	oreja	ear
👂🏻		ear: light skin tone
👂🏼		ear: medium-light skin tone
👂🏽		ear: medium skin tone
👂🏾		ear: medium-dark skin tone
👂🏿		ear: dark skin tone
🦻	oreja con audífono	ear with hearing aid
🦻🏻		ear with hearing aid: light skin tone
🦻🏼		ear with hearing aid: medium-light skin tone
🦻🏽		ear with hearing aid: medium skin tone
🦻🏾		ear with hearing aid: medium-dark skin tone
🦻🏿		ear with hearing aid: dark skin tone
👃	nariz	nose
👃🏻		nose: light skin tone
👃🏼		nose: medium-light skin tone
👃🏽		nose: medium skin tone
👃🏾		nose: medium-dark skin tone
👃🏿		nose: dark skin tone
🧠	cerebro	brain
🫀	corazón humano	anatomical heart
🫁	pulmones	lungs
🦷	diente	tooth
🦴	hueso	bone
👀	ojos	eyes
👁️		eye
👅	lengua	tongue
👄	boca	mouth
🫦	labio mordido	biting lip
👶	bebé	baby
👶🏻		baby: light skin tone
👶🏼		baby: medium-light skin tone
👶🏽		baby: medium skin tone
👶🏾		baby: medium-dark skin tone
👶🏿		baby: dark skin tone
🧒	infante	child
🧒🏻		child: light skin tone
🧒🏼		child: medium-light skin tone
🧒🏽		child: medium skin tone
🧒🏾		child: medium-dark skin tone
🧒🏿		child: dark skin tone
👦	niño	boy
👦🏻		boy: light skin tone
👦🏼		boy: medium-light skin tone
👦🏽		boy: medium skin tone
👦🏾		boy: medium-dark skin tone
👦🏿		boy: dark skin tone
👧	niña	girl
👧🏻		girl: light skin tone
👧🏼		girl: medium-light skin tone
👧🏽		girl: medium skin tone
👧🏾		girl: medium-dark skin tone
👧🏿		girl: dark skin tone
🧑	persona adulta	person
🧑🏻		person: light skin tone
🧑🏼		person: medium-light skin tone
🧑🏽		person: medium skin tone
🧑🏾		person: medium-dark skin tone
🧑🏿		person: dark skin tone
👱	persona adulta rubia	person: blond hair
👱🏻		person: light skin tone, blond hair
👱🏼		person: medium-light skin tone, blond hair
👱🏽		person: medium skin tone, blond hair
👱🏾		person: medium-dark skin tone, blond hair
👱🏿		person: dark skin tone, blond hair
👨	hombre	man
👨🏻		man: light skin tone
👨🏼		man: medium-light skin tone
👨🏽		man: medium skin tone
👨🏾		man: medium-dark skin tone
👨🏿		man: dark skin tone
🧔	persona con barba	person: beard
🧔🏻		person: light skin tone, beard
🧔🏼		person: medium-light skin tone, beard
🧔🏽		person: medium skin tone, beard
🧔🏾		person: medium-dark skin tone, beard
🧔🏿		person: dark skin tone, beard
🧔‍♂️		man: beard
🧔🏻‍♂️		man: light skin tone, beard
🧔🏼‍♂️		man: medium-light skin tone, beard
🧔🏽‍♂️		man: medium skin tone, beard
🧔🏾‍♂️		man: medium-dark skin tone, beard
🧔🏿‍♂️		man: dark skin tone, beard
🧔‍♀️		woman: beard
🧔🏻‍♀️		woman: light skin tone, beard
🧔🏼‍♀️		woman: medium-light skin tone, beard
🧔🏽‍♀️		woman: medium skin tone, beard
🧔🏾‍♀️		woman: medium-dark skin tone, beard
🧔🏿‍♀️		woman: dark skin tone, beard
👨‍🦰		man: red hair
👨🏻‍🦰		man: light skin tone, red hair
👨🏼‍🦰		man: medium-light skin tone, red hair
👨🏽‍🦰		man: medium skin tone, red hair
👨🏾‍🦰		man: medium-dark skin tone, red hair
👨🏿‍🦰		man: dark skin tone, red hair
👨‍🦱		man: curly hair
👨🏻‍🦱		man: light skin tone, curly hair
👨🏼‍🦱		man: medium-light skin tone, curly hair
👨🏽‍🦱		man: medium skin tone, curly hair
👨🏾‍🦱		man: medium-dark skin tone, curly hair
👨🏿‍🦱		man: dark skin tone, curly hair
👨‍🦳		man: white hair
👨🏻‍🦳		man: light skin tone, white hair
👨🏼‍🦳		man: medium-light skin tone, white hair
👨🏽‍🦳		man: medium skin tone, white hair
👨🏾‍🦳		man: medium-dark skin tone, white hair
👨🏿‍🦳		man: dark skin tone, white hair
👨‍🦲		man: bald
👨🏻‍🦲		man: light skin tone, bald
👨🏼‍🦲		man: medium-light skin tone, bald
👨🏽‍🦲		man: medium skin tone, bald
👨🏾‍🦲		man: medium-dark skin tone, bald
👨🏿‍🦲		man: dark skin tone, bald
👩	mujer	woman
👩🏻		woman: light skin tone
👩🏼		woman: medium-light skin tone
👩🏽		woman: medium skin tone
👩🏾		woman: medium-dark skin tone
👩🏿		woman: dark skin tone
👩‍🦰		woman: red hair
👩🏻‍🦰		woman: light skin tone, red hair
👩🏼‍🦰		woman: medium-light skin tone, red hair
👩🏽‍🦰		woman: medium skin tone, red hair
👩🏾‍🦰		woman: medium-dark skin tone, red hair
👩🏿‍🦰		woman: dark skin tone, red hair
🧑‍🦰		person: red hair
🧑🏻‍🦰		person: light skin tone, red hair
🧑🏼‍🦰		person: medium-light skin tone, red hair
🧑🏽‍🦰		person: medium skin tone, red hair
🧑🏾‍🦰		person: medium-dark skin tone, red hair
🧑🏿‍🦰		person: dark skin tone, red hair
👩‍🦱		woman: curly hair
👩🏻‍🦱		woman: light skin tone, curly hair
👩🏼‍🦱		woman: medium-light skin tone, curly hair
👩🏽‍🦱		woman: medium skin tone, curly hair
👩🏾‍🦱		woman: medium-dark skin tone, curly hair
👩🏿‍🦱		woman: dark skin tone, curly hair
🧑‍🦱		person: curly hair
🧑🏻‍🦱		person: light skin tone, curly hair
🧑🏼‍🦱		person: medium-light skin tone, curly hair
🧑🏽‍🦱		person: medium skin tone, curly hair
🧑🏾‍🦱		person: medium-dark skin tone, curly hair
🧑🏿‍🦱		person: dark skin tone, curly hair
👩‍🦳		woman: white hair
👩🏻‍🦳		woman: light skin tone, white hair
👩🏼‍🦳		woman: medium-light skin tone, white hair
👩🏽‍🦳		woman: medium skin tone, white hair
👩🏾‍🦳		woman: medium-dark skin tone, white hair
👩🏿‍🦳		woman: dark skin tone, white hair
🧑‍🦳		person: white hair
🧑🏻‍🦳		person: light skin tone, white hair
🧑🏼‍🦳		person: medium-light skin tone, white hair
🧑🏽‍🦳		person: medium skin tone, white hair
🧑🏾‍🦳		person: medium-dark skin tone, white hair
🧑🏿‍🦳		person: dark skin tone, white hair
👩‍🦲		woman: bald
👩🏻‍🦲		woman: light skin tone, bald
👩🏼‍🦲		woman: medium-light skin tone, bald
👩🏽‍🦲		woman: medium skin tone, bald
👩🏾‍🦲		woman: medium-dark skin tone, bald
👩🏿‍🦲		woman: dark skin tone, bald
🧑‍🦲		person: bald
🧑🏻‍🦲		person: light skin tone, bald
🧑🏼‍🦲		person: medium-light skin tone, bald
🧑🏽‍🦲		person: medium skin tone, bald
🧑🏾‍🦲		person: medium-dark skin tone, bald
🧑🏿‍🦲		person: dark skin tone, bald
👱‍♀️		woman: blond hair
👱🏻‍♀️		woman: light skin tone, blond hair
👱🏼‍♀️		woman: medium-light skin tone, blond hair
👱🏽‍♀️		woman: medium skin tone, blond hair
👱🏾‍♀️		woman: medium-dark skin tone, blond hair
👱🏿‍♀️		woman: dark skin tone, blond hair
👱‍♂️		man: blond hair
👱🏻‍♂️		man: light skin tone, blond hair
👱🏼‍♂️		man: medium-light skin tone, blond hair
👱🏽‍♂️		man: medium skin tone, blond hair
👱🏾‍♂️		man: medium-dark skin tone, blond hair
👱🏿‍♂️		man: dark skin tone, blond hair
🧓	persona mayor	older person
🧓🏻		older person: light skin tone
🧓🏼		older person: medium-light skin tone
🧓🏽		older person: medium skin tone
🧓🏾		older person: medium-dark skin tone
🧓🏿		older person: dark skin tone
👴	anciano	old man
👴🏻		old man: light skin tone
👴🏼		old man: medium-light skin tone
👴🏽		old man: medium skin tone
👴🏾		old man: medium-dark skin tone
👴🏿		old man: dark skin tone
👵	anciana	old woman
👵🏻		old woman: light skin tone
👵🏼		old woman: medium-light skin tone
👵🏽		old woman: medium skin tone
👵🏾		old woman: medium-dark skin tone
👵🏿		old woman: dark skin tone
🙍	persona frunciendo el ceño	person frowning
🙍🏻		person frowning: light skin tone
🙍🏼		person frowning: medium-light skin tone
🙍🏽		person frowning: medium skin tone
🙍🏾		person frowning: medium-dark skin tone
🙍🏿		person frowning: dark skin tone
🙍‍♂️		man frowning
🙍🏻‍♂️		man frowning: light skin tone
🙍🏼‍♂️		man frowning: medium-light skin tone
🙍🏽‍♂️		man frowning: medium skin tone
🙍🏾‍♂️		man frowning: medium-dark skin tone
🙍🏿‍♂️		man frowning: dark skin tone
🙍‍♀️		woman frowning
🙍🏻‍♀️		woman frowning: light skin tone
🙍🏼‍♀️		woman frowning: medium-light skin tone
🙍🏽‍♀️		woman frowning: medium skin tone
🙍🏾‍♀️		woman frowning: medium-dark skin tone
🙍🏿‍♀️		woman frowning: dark skin tone
🙎	persona haciendo pucheros	person pouting
🙎🏻		person pouting: light skin tone
🙎🏼		person pouting: medium-light skin tone
🙎🏽		person pouting: medium skin tone
🙎🏾		person pouting: medium-dark skin tone
🙎🏿		person pouting: dark skin tone
🙎‍♂️		man pouting
🙎🏻‍♂️		man pouting: light skin tone
🙎🏼‍♂️		man pouting: medium-light skin tone
🙎🏽‍♂️		man pouting: medium skin tone
🙎🏾‍♂️		man pouting: medium-dark skin tone
🙎🏿‍♂️		man pouting: dark skin tone
🙎‍♀️		woman pouting
🙎🏻‍♀️		woman pouting: light skin tone
🙎🏼‍♀️		woman pouting: medium-light skin tone
🙎🏽‍♀️		woman pouting: medium skin tone
🙎🏾‍♀️		woman pouting: medium-dark skin tone
🙎🏿‍♀️		woman pouting: dark skin tone
🙅	persona haciendo el gesto de "no"	person gesturing NO
🙅🏻		person gesturing NO: light skin tone
🙅🏼		person gesturing NO: medium-light skin tone
🙅🏽		person gesturing NO: medium skin tone
🙅🏾		person gesturing NO: medium-dark skin tone
🙅🏿		person gesturing NO: dark skin tone
🙅‍♂️		man gesturing NO
🙅🏻‍♂️		man gesturing NO: light skin tone
🙅🏼‍♂️		man gesturing NO: medium-light skin tone
🙅🏽‍♂️		man gesturing NO: medium skin tone
🙅🏾‍♂️		man gesturing NO: medium-dark skin tone
🙅🏿‍♂️		man gesturing NO: dark skin tone
🙅‍♀️		woman gesturing NO
🙅🏻‍♀️		woman gesturing NO: light skin tone
🙅🏼‍♀️		woman gesturing NO: medium-light skin tone
🙅🏽‍♀️		woman gesturing NO: medium skin tone
🙅🏾‍♀️		woman gesturing NO: medium-dark skin tone
🙅🏿‍♀️		woman gesturing NO: dark skin tone
🙆	persona haciendo el gesto de "de acuerdo"	person gesturing OK
🙆🏻		person gesturing OK: light skin tone
🙆🏼		person gesturing OK: medium-light skin tone
🙆🏽		person gesturing OK: medium skin tone
🙆🏾		person gesturing OK: medium-dark skin tone
🙆🏿		person gesturing OK: dark skin tone
🙆‍♂️		man gesturing OK
🙆🏻‍♂️		man gesturing OK: light skin tone
🙆🏼‍♂️		man gesturing OK: medium-light skin tone
🙆🏽‍♂️		man gesturing OK: medium skin tone
🙆🏾‍♂️		man gesturing OK: medium-dark skin tone
🙆🏿‍♂️		man gesturing OK: dark skin tone
🙆‍♀️		woman gesturing OK
🙆🏻‍♀️		woman gesturing OK: light skin tone
🙆🏼‍♀️		woman gesturing OK: medium-light skin tone
🙆🏽‍♀️		woman gesturing OK: medium skin tone
🙆🏾‍♀️		woman gesturing OK: medium-dark skin tone
🙆🏿‍♀️		woman gesturing OK: dark skin tone
💁	persona de mostrador de información	person tipping hand
💁🏻		person tipping hand: light skin tone
💁🏼		person tipping hand: medium-light skin tone
💁🏽		person tipping hand: medium skin tone
💁🏾		person tipping hand: medium-dark skin tone
💁🏿		person tipping hand: dark skin tone
💁‍♂️		man tipping hand
💁🏻‍♂️		man tipping hand: light skin tone
💁🏼‍♂️		man tipping hand: medium-light skin tone
💁🏽‍♂️		man tipping hand: medium skin tone
💁🏾‍♂️		man tipping hand: medium-dark skin tone
💁🏿‍♂️		man tipping hand: dark skin tone
💁‍♀️		woman tipping hand
💁🏻‍♀️		woman tipping hand: light skin tone
💁🏼‍♀️		woman tipping hand: medium-light skin tone
💁🏽‍♀️		woman tipping hand: medium skin tone
💁🏾‍♀️		woman tipping hand: medium-dark skin tone
💁🏿‍♀️		woman tipping hand: dark skin tone
🙋	persona con la mano levantada	person raising hand
🙋🏻		person raising hand: light skin tone
🙋🏼		person raising hand: medium-light skin tone
🙋🏽		person raising hand: medium skin tone
🙋🏾		person raising hand: medium-dark skin tone
🙋🏿		person raising hand: dark skin tone
🙋‍♂️		man raising hand
🙋🏻‍♂️		man raising hand: light skin tone
🙋🏼‍♂️		man raising hand: medium-light skin tone
🙋🏽‍♂️		man raising hand: medium skin tone
🙋🏾‍♂️		man raising hand: medium-dark skin tone
🙋🏿‍♂️		man raising hand: dark skin tone
🙋‍♀️		woman raising hand
🙋🏻‍♀️		woman raising hand: light skin tone
🙋🏼‍♀️		woman raising hand: medium-light skin tone
🙋🏽‍♀️		woman raising hand: medium skin tone
🙋🏾‍♀️		woman raising hand: medium-dark skin tone
🙋🏿‍♀️		woman raising hand: dark skin tone
🧏	persona sorda	deaf person
🧏🏻		deaf person: light skin tone
🧏🏼		deaf person: medium-light skin tone
🧏🏽		deaf person: medium skin tone
🧏🏾		deaf person: medium-dark skin tone
🧏🏿		deaf person: dark skin tone
🧏‍♂️		deaf man
🧏🏻‍♂️		deaf man: light skin tone
🧏🏼‍♂️		deaf man: medium-light skin tone
🧏🏽‍♂️		deaf man: medium skin tone
🧏🏾‍♂️		deaf man: medium-dark skin tone
🧏🏿‍♂️		deaf man: dark skin tone
🧏‍♀️		deaf woman
🧏🏻‍♀️		deaf woman: light skin tone
🧏🏼‍♀️		deaf woman: medium-light skin tone
🧏🏽‍♀️		deaf woman: medium skin tone
🧏🏾‍♀️		deaf woman: medium-dark skin tone
🧏🏿‍♀️		deaf woman: dark skin tone
🙇	persona haciendo una reverencia	person bowing
🙇🏻		person bowing: light skin tone
🙇🏼		person bowing: medium-light skin tone
🙇🏽		person bowing: medium skin tone
🙇🏾		person bowing: medium-dark skin tone
🙇🏿		person bowing: dark skin tone
🙇‍♂️		man bowing
🙇🏻‍♂️		man bowing: light skin tone
🙇🏼‍♂️		man bowing: medium-light skin tone
🙇🏽‍♂️		man bowing: medium skin tone
🙇🏾‍♂️		man bowing: medium-dark skin tone
🙇🏿‍♂️		man bowing: dark skin tone
🙇‍♀️		woman bowing
🙇🏻‍♀️		woman bowing: light skin tone
🙇🏼‍♀️		woman bowing: medium-light skin tone
🙇🏽‍♀️		woman bowing: medium skin tone
🙇🏾‍♀️		woman bowing: medium-dark skin tone
🙇🏿‍♀️		woman bowing: dark skin tone
🤦	persona con la mano en la frente	person facepalming
🤦🏻		person facepalming: light skin tone
🤦🏼		person facepalming: medium-light skin tone
🤦🏽		person facepalming: medium skin tone
🤦🏾		person facepalming: medium-dark skin tone
🤦🏿		person facepalming: dark skin tone
🤦‍♂️		man facepalming
🤦🏻‍♂️		man facepalming: light skin tone
🤦🏼‍♂️		man facepalming: medium-light skin tone
🤦🏽‍♂️		man facepalming: medium skin tone
🤦🏾‍♂️		man facepalming: medium-dark skin tone
🤦🏿‍♂️		man facepalming: dark skin tone
🤦‍♀️		woman facepalming
🤦🏻‍♀️		woman facepalming: light skin tone
🤦🏼‍♀️		woman facepalming: medium-light skin tone
🤦🏽‍♀️		woman facepalming: medium skin tone
🤦🏾‍♀️		woman facepalming: medium-dark skin tone
🤦🏿‍♀️		woman facepalming: dark skin tone
🤷	persona encogida de hombros	person shrugging
🤷🏻		person shrugging: light skin tone
🤷🏼		person shrugging: medium-light skin tone
🤷🏽		person shrugging: medium skin tone
🤷🏾		person shrugging: medium-dark skin tone
🤷🏿		person shrugging: dark skin tone
🤷‍♂️		man shrugging
🤷🏻‍♂️		man shrugging: light skin tone
🤷🏼‍♂️		man shrugging: medium-light skin tone
🤷🏽‍♂️		man shrugging: medium skin tone
🤷🏾‍♂️		man shrugging: medium-dark skin tone
🤷🏿‍♂️		man shrugging: dark skin tone
🤷‍♀️		woman shrugging
🤷🏻‍♀️		woman shrugging: light skin tone
🤷🏼‍♀️		woman shrugging: medium-light skin tone
🤷🏽‍♀️		woman shrugging: medium skin tone
🤷🏾‍♀️		woman shrugging: medium-dark skin tone
🤷🏿‍♀️		woman shrugging: dark skin tone
🧑‍⚕️		health worker
🧑🏻‍⚕️		health worker: light skin tone
🧑🏼‍⚕️		health worker: medium-light skin tone
🧑🏽‍⚕️		health worker: medium skin tone
🧑🏾‍⚕️		health worker: medium-dark skin tone
🧑🏿‍⚕️		health worker: dark skin tone
👨‍⚕️		man health worker
👨🏻‍⚕️		man health worker: light skin tone
👨🏼‍⚕️		man health worker: medium-light skin tone
👨🏽‍⚕️		man health worker: medium skin tone
👨🏾‍⚕️		man health worker: medium-dark skin tone
👨🏿‍⚕️		man health worker: dark skin tone
👩‍⚕️		woman health worker
👩🏻‍⚕️		woman health worker: light skin tone
👩🏼‍⚕️		woman health worker: medium-light skin tone
👩🏽‍⚕️		woman health worker: medium skin tone
👩🏾‍⚕️		woman health worker: medium-dark skin tone
👩🏿‍⚕️		woman health worker: dark skin tone
🧑‍🎓	estudiante	student
🧑🏻‍🎓		student: light skin tone
🧑🏼‍🎓		student: medium-light skin tone
🧑🏽‍🎓		student: medium skin tone
🧑🏾‍🎓		student: medium-dark skin tone
🧑🏿‍🎓		student: dark skin tone
👨‍🎓	estudiante hombre	man student
👨🏻‍🎓		man student: light skin tone
👨🏼‍🎓		man student: medium-light skin tone
👨🏽‍🎓		man student: medium skin tone
👨🏾‍🎓		man student: medium-dark skin tone
👨🏿‍🎓		man student: dark skin tone
👩‍🎓	estudiante mujer	woman student
👩🏻‍🎓		woman student: light skin tone
👩🏼‍🎓		woman student: medium-light skin tone
👩🏽‍🎓		woman student: medium skin tone
👩🏾‍🎓		woman student: medium-dark skin tone
👩🏿‍🎓		woman student: dark skin tone
🧑‍🏫	docente	teacher
🧑🏻‍🏫		teacher: light skin tone
🧑🏼‍🏫		teacher: medium-light skin tone
🧑🏽‍🏫		teacher: medium skin tone
🧑🏾‍🏫		teacher: medium-dark skin tone
🧑🏿‍🏫		teacher: dark skin tone
👨‍🏫	docente hombre	man teacher
👨🏻‍🏫		man teacher: light skin tone
👨🏼‍🏫		man teacher: medium-light skin tone
👨🏽‍🏫		man teacher: medium skin tone
👨🏾‍🏫		man teacher: medium-dark skin tone
👨🏿‍🏫		man teacher: dark skin tone
👩‍🏫	docente mujer	woman teacher
👩🏻‍🏫		woman teacher: light skin tone
👩🏼‍🏫		woman teacher: medium-light skin tone
👩🏽‍🏫		woman teacher: medium skin tone
👩🏾‍🏫		woman teacher: medium-dark skin tone
👩🏿‍🏫		woman teacher: dark skin tone
🧑‍⚖️		judge
🧑🏻‍⚖️		judge: light skin tone
🧑🏼‍⚖️		judge: medium-light skin tone
🧑🏽‍⚖️		judge: medium skin tone
🧑🏾‍⚖️		judge: medium-dark skin tone
🧑🏿‍⚖️		judge: dark skin tone
👨‍⚖️		man judge
👨🏻‍⚖️		man judge: light skin tone
👨🏼‍⚖️		man judge: medium-light skin tone
👨🏽‍⚖️		man judge: medium skin tone
👨🏾‍⚖️		man judge: medium-dark skin tone
👨🏿‍⚖️		man judge: dark skin tone
👩‍⚖️		woman judge
👩🏻‍⚖️		woman judge: light skin tone
👩🏼‍⚖️		woman judge: medium-light skin tone
👩🏽‍⚖️		woman judge: medium skin tone
👩🏾‍⚖️		woman judge: medium-dark skin tone
👩🏿‍⚖️		woman judge: dark skin tone
🧑‍🌾	profesional de la agricultura	farmer
🧑🏻‍🌾		farmer: light skin tone
🧑🏼‍🌾		farmer: medium-light skin tone
🧑🏽‍🌾		farmer: medium skin tone
🧑🏾‍🌾		farmer: medium-dark skin tone
🧑🏿‍🌾		farmer: dark skin tone
👨‍🌾	profesional de la agricultura hombre	man farmer
👨🏻‍🌾		man farmer: light skin tone
👨🏼‍🌾		man farmer: medium-light skin tone
👨🏽‍🌾		man farmer: medium skin tone
👨🏾‍🌾		man farmer: medium-dark skin tone
👨🏿‍🌾		man farmer: dark skin tone
👩‍🌾	profesional de la agricultura mujer	woman farmer
👩🏻‍🌾		woman farmer: light skin tone
👩🏼‍🌾		woman farmer: medium-light skin tone
👩🏽‍🌾		woman farmer: medium skin tone
👩🏾‍🌾		woman farmer: medium-dark skin tone
👩🏿‍🌾		woman farmer: dark skin tone
🧑‍🍳	chef	cook
🧑🏻‍🍳		cook: light skin tone
🧑🏼‍🍳		cook: medium-light skin tone
🧑🏽‍🍳		cook: medium skin tone
🧑🏾‍🍳		cook: medium-dark skin tone
🧑🏿‍🍳		cook: dark skin tone
👨‍🍳	chef hombre	man cook
👨🏻‍🍳		man cook: light skin tone
👨🏼‍🍳		man cook: medium-light skin tone
👨🏽‍🍳		man cook: medium skin tone
👨🏾‍🍳		man cook: medium-dark skin tone
👨🏿‍🍳		man cook: dark skin tone
👩‍🍳	chef mujer	woman cook
👩🏻‍🍳		woman cook: light skin tone
👩🏼‍🍳		woman cook: medium-light skin tone
👩🏽‍🍳		woman cook: medium skin tone
👩🏾‍🍳		woman cook: medium-dark skin tone
👩🏿‍🍳		woman cook: dark skin tone
🧑‍🔧	profesional de la mecánica	mechanic
🧑🏻‍🔧		mechanic: light skin tone
🧑🏼‍🔧		mechanic: medium-light skin tone
🧑🏽‍🔧		mechanic: medium skin tone
🧑🏾‍🔧		mechanic: medium-dark skin tone
🧑🏿‍🔧		mechanic: dark skin tone
👨‍🔧	profesional de la mecánica hombre	man mechanic
👨🏻‍🔧		man mechanic: light skin tone
👨🏼‍🔧		man mechanic: medium-light skin tone
👨🏽‍🔧		man mechanic: medium skin tone
👨🏾‍🔧		man mechanic: medium-dark skin tone
👨🏿‍🔧		man mechanic: dark skin tone
👩‍🔧	profesional de la mecánica mujer	woman mechanic
👩🏻‍🔧		woman mechanic: light skin tone
👩🏼‍🔧		woman mechanic: medium-light skin tone
👩🏽‍🔧		woman mechanic: medium skin tone
👩🏾‍🔧		woman mechanic: medium-dark skin tone
👩🏿‍🔧		woman mechanic: dark skin tone
🧑‍🏭	profesional industrial	factory worker
🧑🏻‍🏭		factory worker: light skin tone
🧑🏼‍🏭		factory worker: medium-light skin tone
🧑🏽‍🏭		factory worker: medium skin tone
🧑🏾‍🏭		factory worker: medium-dark skin tone
🧑🏿‍🏭		factory worker: dark skin tone
👨‍🏭	profesional industrial hombre	man factory worker
👨🏻‍🏭		man factory worker: light skin tone
👨🏼‍🏭		man factory worker: medium-light skin tone
👨🏽‍🏭		man factory worker: medium skin tone
👨🏾‍🏭		man factory worker: medium-dark skin tone
👨🏿‍🏭		man factory worker: dark skin tone
👩‍🏭	profesional industrial mujer	woman factory worker
👩🏻‍🏭		woman factory worker: light skin tone
👩🏼‍🏭		woman factory worker: medium-light skin tone
👩🏽‍🏭		woman factory worker: medium skin tone
👩🏾‍🏭		woman factory worker: medium-dark skin tone
👩🏿‍🏭		woman factory worker: dark skin tone
🧑‍💼	oficinista	office worker
🧑🏻‍💼		office worker: light skin tone
🧑🏼‍💼		office worker: medium-light skin tone
🧑🏽‍💼		office worker: medium skin tone
🧑🏾‍💼		office worker: medium-dark skin tone
🧑🏿‍💼		office worker: dark skin tone
👨‍💼	oficinista hombre	man office worker
👨🏻‍💼		man office worker: light skin tone
👨🏼‍💼		man office worker: medium-light skin tone
👨🏽‍💼		man office worker: medium skin tone
👨🏾‍💼		man office worker: medium-dark skin tone
👨🏿‍💼		man office worker: dark skin tone
👩‍💼	oficinista mujer	woman office worker
👩🏻‍💼		woman office worker: light skin tone
👩🏼‍💼		woman office worker: medium-light skin tone
👩🏽‍💼		woman office worker: medium skin tone
👩🏾‍💼		woman office worker: medium-dark skin tone
👩🏿‍💼		woman office worker: dark skin tone
🧑‍🔬	profesional de la ciencia	scientist
🧑🏻‍🔬		scientist: light skin tone
🧑🏼‍🔬		scientist: medium-light skin tone
🧑🏽‍🔬		scientist: medium skin tone
🧑🏾‍🔬		scientist: medium-dark skin tone
🧑🏿‍🔬		scientist: dark skin tone
👨‍🔬	profesional de la ciencia hombre	man scientist
👨🏻‍🔬		man scientist: light skin tone
👨🏼‍🔬		man scientist: medium-light skin tone
👨🏽‍🔬		man scientist: medium skin tone
👨🏾‍🔬		man scientist: medium-dark skin tone
👨🏿‍🔬		man scientist: dark skin tone
👩‍🔬	profesional de la ciencia mujer	woman scientist
👩🏻‍🔬		woman scientist: light skin tone
👩🏼‍🔬		woman scientist: medium-light skin tone
👩🏽‍🔬		woman scientist: medium skin tone
👩🏾‍🔬		woman scientist: medium-dark skin tone
👩🏿‍🔬		woman scientist: dark skin tone
🧑‍💻	profesional de la tecnología	technologist
🧑🏻‍💻		technologist: light skin tone
🧑🏼‍💻		technologist: medium-light skin tone
🧑🏽‍💻		technologist: medium skin tone
🧑🏾‍💻		technologist: medium-dark skin tone
🧑🏿‍💻		technologist: dark skin tone
👨‍💻	profesional de la tecnología hombre	man technologist
👨🏻‍💻		man technologist: light skin tone
👨🏼‍💻		man technologist: medium-light skin tone
👨🏽‍💻		man technologist: medium skin tone
👨🏾‍💻		man technologist: medium-dark skin tone
👨🏿‍💻		man technologist: dark skin tone
👩‍💻	profesional de la tecnología mujer	woman technologist
👩🏻‍💻		woman technologist: light skin tone
👩🏼‍💻		woman technologist: medium-light skin tone
👩🏽‍💻		woman technologist: medium skin tone
👩🏾‍💻		woman technologist: medium-dark skin tone
👩🏿‍💻		woman technologist: dark skin tone
🧑‍🎤	cantante	singer
🧑🏻‍🎤		singer: light skin tone
🧑🏼‍🎤		singer: medium-light skin tone
🧑🏽‍🎤		singer: medium skin tone
🧑🏾‍🎤		singer: medium-dark skin tone
🧑🏿‍🎤		singer: dark skin tone
👨‍🎤	cantante hombre	man singer
👨🏻‍🎤		man singer: light skin tone
👨🏼‍🎤		man singer: medium-light skin tone
👨🏽‍🎤		man singer: medium skin tone
👨🏾‍🎤		man singer: medium-dark skin tone
👨🏿‍🎤		man singer: dark skin tone
👩‍🎤	cantante mujer	woman singer
👩🏻‍🎤		woman singer: light skin tone
👩🏼‍🎤		woman singer: medium-light skin tone
👩🏽‍🎤		woman singer: medium skin tone
👩🏾‍🎤		woman singer: medium-dark skin tone
👩🏿‍🎤		woman singer: dark skin tone
🧑‍🎨	artista	artist
🧑🏻‍🎨		artist: light skin tone
🧑🏼‍🎨		artist: medium-light skin tone
🧑🏽‍🎨		artist: medium skin tone
🧑🏾‍🎨		artist: medium-dark skin tone
🧑🏿‍🎨		artist: dark skin tone
👨‍🎨	artista hombre	man artist
👨🏻‍🎨		man artist: light skin tone
👨🏼‍🎨		man artist: medium-light skin tone
👨🏽‍🎨		man artist: medium skin tone
👨🏾‍🎨		man artist: medium-dark skin tone
👨🏿‍🎨		man artist: dark skin tone
👩‍🎨	artista mujer	woman artist
👩🏻‍🎨		woman artist: light skin tone
👩🏼‍🎨		woman artist: medium-light skin tone
👩🏽‍🎨		woman artist: medium skin tone
👩🏾‍🎨		woman artist: medium-dark skin tone
👩🏿‍🎨		woman artist: dark skin tone
🧑‍✈️		pilot
🧑🏻‍✈️		pilot: light skin tone
🧑🏼‍✈️		pilot: medium-light skin tone
🧑🏽‍✈️		pilot: medium skin tone
🧑🏾‍✈️		pilot: medium-dark skin tone
🧑🏿‍✈️		pilot: dark skin tone
👨‍✈️		man pilot
👨🏻‍✈️		man pilot: light skin tone
👨🏼‍✈️		man pilot: medium-light skin tone
👨🏽‍✈️		man pilot: medium skin tone
👨🏾‍✈️		man pilot: medium-dark skin tone
👨🏿‍✈️		man pilot: dark skin tone
👩‍✈️		woman pilot
👩🏻‍✈️		woman pilot: light skin tone
👩🏼‍✈️		woman pilot: medium-light skin tone
👩🏽‍✈️		woman pilot: medium skin tone
👩🏾‍✈️		woman pilot: medium-dark skin tone
👩🏿‍✈️		woman pilot: dark skin tone
🧑‍🚀	astronauta	astronaut
🧑🏻‍🚀		astronaut: light skin tone
🧑🏼‍🚀		astronaut: medium-light skin tone
🧑🏽‍🚀		astronaut: medium skin tone
🧑🏾‍🚀		astronaut: medium-dark skin tone
🧑🏿‍🚀		astronaut: dark skin tone
👨‍🚀	astronauta hombre	man astronaut
👨🏻‍🚀		man astronaut: light skin tone
👨🏼‍🚀		man astronaut: medium-light skin tone
👨🏽‍🚀		man astronaut: medium skin tone
👨🏾‍🚀		man astronaut: medium-dark skin tone
👨🏿‍🚀		man astronaut: dark skin tone
👩‍🚀	astronauta mujer	woman astronaut
👩🏻‍🚀		woman astronaut: light skin tone
👩🏼‍🚀		woman astronaut: medium-light skin tone
👩🏽‍🚀		woman astronaut: medium skin tone
👩🏾‍🚀		woman astronaut: medium-dark skin tone
👩🏿‍🚀		woman astronaut: dark skin tone
🧑‍🚒	bombero	firefighter
🧑🏻‍🚒		firefighter: light skin tone
🧑🏼‍🚒		firefighter: medium-light skin tone
🧑🏽‍🚒		firefighter: medium skin tone
🧑🏾‍🚒		firefighter: medium-dark skin tone
🧑🏿‍🚒		firefighter: dark skin tone
👨‍🚒	bombero hombre	man firefighter
👨🏻‍🚒		man firefighter: light skin tone
👨🏼‍🚒		man firefighter: medium-light skin tone
👨🏽‍🚒		man firefighter: medium skin tone
👨🏾‍🚒		man firefighter: medium-dark skin tone
👨🏿‍🚒		man firefighter: dark skin tone
👩‍🚒	bombera	woman firefighter
👩🏻‍🚒		woman firefighter: light skin tone
👩🏼‍🚒		woman firefighter: medium-light skin tone
👩🏽‍🚒		woman firefighter: medium skin tone
👩🏾‍🚒		woman firefighter: medium-dark skin tone
👩🏿‍🚒		woman firefighter: dark skin tone
👮	agente de policía	police officer
👮🏻		police officer: light skin tone
👮🏼		police officer: medium-light skin tone
👮🏽		police officer: medium skin tone
👮🏾		police officer: medium-dark skin tone
👮🏿		police officer: dark skin tone
👮‍♂️		man police officer
👮🏻‍♂️		man police officer: light skin tone
👮🏼‍♂️		man police officer: medium-light skin tone
👮🏽‍♂️		man police officer: medium skin tone
👮🏾‍♂️		man police officer: medium-dark skin tone
👮🏿‍♂️		man police officer: dark skin tone
👮‍♀️		woman police officer
👮🏻‍♀️		woman police officer: light skin tone
👮🏼‍♀️		woman police officer: medium-light skin tone
👮🏽‍♀️		woman police officer: medium skin tone
👮🏾‍♀️		woman police officer: medium-dark skin tone
👮🏿‍♀️		woman police officer: dark skin tone
🕵️		detective
🕵🏻		detective: light skin tone
🕵🏼		detective: medium-light skin tone
🕵🏽		detective: medium skin tone
🕵🏾		detective: medium-dark skin tone
🕵🏿		detective: dark skin tone
🕵️‍♂️		man detective
🕵🏻‍♂️		man detective: light skin tone
🕵🏼‍♂️		man detective: medium-light skin tone
🕵🏽‍♂️		man detective: medium skin tone
🕵🏾‍♂️		man detective: medium-dark skin tone
🕵🏿‍♂️		man detective: dark skin tone
🕵️‍♀️		woman detective
🕵🏻‍♀️		woman detective: light skin tone
🕵🏼‍♀️		woman detective: medium-light skin tone
🕵🏽‍♀️		woman detective: medium skin tone
🕵🏾‍♀️		woman detective: medium-dark skin tone
🕵🏿‍♀️		woman detective: dark skin tone
💂	guardia	guard
💂🏻		guard: light skin tone
💂🏼		guard: medium-light skin tone
💂🏽		guard: medium skin tone
💂🏾		guard: medium-dark skin tone
💂🏿		guard: dark skin tone
💂‍♂️		man guard
💂🏻‍♂️		man guard: light skin tone
💂🏼‍♂️		man guard: medium-light skin tone
💂🏽‍♂️		man guard: medium skin tone
💂🏾‍♂️		man guard: medium-dark skin tone
💂🏿‍♂️		man guard: dark skin tone
💂‍♀️		woman guard
💂🏻‍♀️		woman guard: light skin tone
💂🏼‍♀️		woman guard: medium-light skin tone
💂🏽‍♀️		woman guard: medium skin tone
💂🏾‍♀️		woman guard: medium-dark skin tone
💂🏿‍♀️		woman guard: dark skin tone
🥷	ninja	ninja
🥷🏻		ninja: light skin tone
🥷🏼		ninja: medium-light skin tone
🥷🏽		ninja: medium skin tone
🥷🏾		ninja: medium-dark skin tone
🥷🏿		ninja: dark skin tone
👷	profesional de la construcción	construction worker
👷🏻		construction worker: light skin tone
👷🏼		construction worker: medium-light skin tone
👷🏽		construction worker: medium skin tone
👷🏾		construction worker: medium-dark skin tone
👷🏿		construction worker: dark skin tone
👷‍♂️		man construction worker
👷🏻‍♂️		man construction worker: light skin tone
👷🏼‍♂️		man construction worker: medium-light skin tone
👷🏽‍♂️		man construction worker: medium skin tone
👷🏾‍♂️		man construction worker: medium-dark skin tone
👷🏿‍♂️		man construction worker: dark skin tone
👷‍♀️		woman construction worker
👷🏻‍♀️		woman construction worker: light skin tone
👷🏼‍♀️		woman construction worker: medium-light skin tone
👷🏽‍♀️		woman construction worker: medium skin tone
👷🏾‍♀️		woman construction worker: medium-dark skin tone
👷🏿‍♀️		woman construction worker: dark skin tone
🫅	persona con corona	person with crown
🫅🏻		person with crown: light skin tone
🫅🏼		person with crown: medium-light skin tone
🫅🏽		person with crown: medium skin tone
🫅🏾		person with crown: medium-dark skin tone
🫅🏿		person with crown: dark skin tone
🤴	príncipe	prince
🤴🏻		prince: light skin tone
🤴🏼		prince: medium-light skin tone
🤴🏽		prince: medium skin tone
🤴🏾		prince: medium-dark skin tone
🤴🏿		prince: dark skin tone
👸	princesa	princess
👸🏻		princess: light skin tone
👸🏼		princess: medium-light skin tone
👸🏽		princess: medium skin tone
👸🏾		princess: medium-dark skin tone
👸🏿		princess: dark skin tone
👳	persona con turbante	person wearing turban
👳🏻		person wearing turban: light skin tone
👳🏼		person wearing turban: medium-light skin tone
👳🏽		person wearing turban: medium skin tone
👳🏾		person wearing turban: medium-dark skin tone
👳🏿		person wearing turban: dark skin tone
👳‍♂️		man wearing turban
👳🏻‍♂️		man wearing turban: light skin tone
👳🏼‍♂️		man wearing turban: medium-light skin tone
👳🏽‍♂️		man wearing turban: medium skin tone
👳🏾‍♂️		man wearing turban: medium-dark skin tone
👳🏿‍♂️		man wearing turban: dark skin tone
👳‍♀️		woman wearing turban
👳🏻‍♀️		woman wearing turban: light skin tone
👳🏼‍♀️		woman wearing turban: medium-light skin tone
👳🏽‍♀️		woman wearing turban: medium skin tone
👳🏾‍♀️		woman wearing turban: medium-dark skin tone
👳🏿‍♀️		woman wearing turban: dark skin tone
👲	persona con gorro chino	person with skullcap
👲🏻		person with skullcap: light skin tone
👲🏼		person with skullcap: medium-light skin tone
👲🏽		person with skullcap: medium skin tone
👲🏾		person with skullcap: medium-dark skin tone
👲🏿		person with skullcap: dark skin tone
🧕	mujer con hiyab	woman with headscarf
🧕🏻		woman with headscarf: light skin tone
🧕🏼		woman with headscarf: medium-light skin tone
🧕🏽		woman with headscarf: medium skin tone
🧕🏾		woman with headscarf: medium-dark skin tone
🧕🏿		woman with headscarf: dark skin tone
🤵	persona con esmoquin	person in tuxedo
🤵🏻		person in tuxedo: light skin tone
🤵🏼		person in tuxedo: medium-light skin tone
🤵🏽		person in tuxedo: medium skin tone
🤵🏾		person in tuxedo: medium-dark skin tone
🤵🏿		person in tuxedo: dark skin tone
🤵‍♂️		man in tuxedo
🤵🏻‍♂️		man in tuxedo: light skin tone
🤵🏼‍♂️		man in tuxedo: medium-light skin tone
🤵🏽‍♂️		man in tuxedo: medium skin tone
🤵🏾‍♂️		man in tuxedo: medium-dark skin tone
🤵🏿‍♂️		man in tuxedo: dark skin tone
🤵‍♀️		woman in tuxedo
🤵🏻‍♀️		woman in tuxedo: light skin tone
🤵🏼‍♀️		woman in tuxedo: medium-light skin tone
🤵🏽‍♀️		woman in tuxedo: medium skin tone
🤵🏾‍♀️		woman in tuxedo: medium-dark skin tone
🤵🏿‍♀️		woman in tuxedo: dark skin tone
👰	persona con velo	person with veil
👰🏻		person with veil: light skin tone
👰🏼		person with veil: medium-light skin tone
👰🏽		person with veil: medium skin tone
👰🏾		person with veil: medium-dark skin tone
👰🏿		person with veil: dark skin tone
👰‍♂️		man with veil
👰🏻‍♂️		man with veil: light skin tone
👰🏼‍♂️		man with veil: medium-light skin tone
👰🏽‍♂️		man with veil: medium skin tone
👰🏾‍♂️		man with veil: medium-dark skin tone
👰🏿‍♂️		man with veil: dark skin tone
👰‍♀️		woman with veil
👰🏻‍♀️		woman with veil: light skin tone
👰🏼‍♀️		woman with veil: medium-light skin tone
👰🏽‍♀️		woman with veil: medium skin tone
👰🏾‍♀️		woman with veil: medium-dark skin tone
👰🏿‍♀️		woman with veil: dark skin tone
🤰	mujer embarazada	pregnant woman
🤰🏻		pregnant woman: light skin tone
🤰🏼		pregnant woman: medium-light skin tone
🤰🏽		pregnant woman: medium skin tone
🤰🏾		pregnant woman: medium-dark skin tone
🤰🏿		pregnant woman: dark skin tone
🫃	hombre embarazado	pregnant man
🫃🏻		pregnant man: light skin tone
🫃🏼		pregnant man: medium-light skin tone
🫃🏽		pregnant man: medium skin tone
🫃🏾		pregnant man: medium-dark skin tone
🫃🏿		pregnant man: dark skin tone
🫄	persona embarazada	pregnant person
🫄🏻		pregnant person: light skin tone
🫄🏼		pregnant person: medium-light skin tone
🫄🏽		pregnant person: medium skin tone
🫄🏾		pregnant person: medium-dark skin tone
🫄🏿		pregnant person: dark skin tone
🤱	lactancia materna	breast-feeding
🤱🏻		breast-feeding: light skin tone
🤱🏼		breast-feeding: medium-light skin tone
🤱🏽		breast-feeding: medium skin tone
🤱🏾		breast-feeding: medium-dark skin tone
🤱🏿		breast-feeding: dark skin tone
👩‍🍼	mujer alimentando a bebé	woman feeding baby
👩🏻‍🍼		woman feeding baby: light skin tone
👩🏼‍🍼		woman feeding baby: medium-light skin tone
👩🏽‍🍼		woman feeding baby: medium skin tone
👩🏾‍🍼		woman feeding baby: medium-dark skin tone
👩🏿‍🍼		woman feeding baby: dark skin tone
👨‍🍼	hombre alimentando a bebé	man feeding baby
👨🏻‍🍼		man feeding baby: light skin tone
👨🏼‍🍼		man feeding baby: medium-light skin tone
👨🏽‍🍼		man feeding baby: medium skin tone
👨🏾‍🍼		man feeding baby: medium-dark skin tone
👨🏿‍🍼		man feeding baby: dark skin tone
🧑‍🍼	persona alimentando a bebé	person feeding baby
🧑🏻‍🍼		person feeding baby: light skin tone
🧑🏼‍🍼		person feeding baby: medium-light skin tone
🧑🏽‍🍼		person feeding baby: medium skin tone
🧑🏾‍🍼		person feeding baby: medium-dark skin tone
🧑🏿‍🍼		person feeding baby: dark skin tone
👼	bebé ángel	baby angel
👼🏻		baby angel: light skin tone
👼🏼		baby angel: medium-light skin tone
👼🏽		baby angel: medium skin tone
👼🏾		baby angel: medium-dark skin tone
👼🏿		baby angel: dark skin tone
🎅	Papá Noel	Santa Claus
🎅🏻		Santa Claus: light skin tone
🎅🏼		Santa Claus: medium-light skin tone
🎅🏽		Santa Claus: medium skin tone
🎅🏾		Santa Claus: medium-dark skin tone
🎅🏿		Santa Claus: dark skin tone
🤶	Mamá Noel	Mrs. Claus
🤶🏻		Mrs. Claus: light skin tone
🤶🏼		Mrs. Claus: medium-light skin tone
🤶🏽		Mrs. Claus: medium skin tone
🤶🏾		Mrs. Claus: medium-dark skin tone
🤶🏿		Mrs. Claus: dark skin tone
🧑‍🎄	Noel	Mx Claus
🧑🏻‍🎄		mx claus: light skin tone
🧑🏼‍🎄		mx claus: medium-light skin tone
🧑🏽‍🎄		mx claus: medium skin tone
🧑🏾‍🎄		mx claus: medium-dark skin tone
🧑🏿‍🎄		mx claus: dark skin tone
🦸	personaje de superhéroe	superhero
🦸🏻		superhero: light skin tone
🦸🏼		superhero: medium-light skin tone
🦸🏽		superhero: medium skin tone
🦸🏾		superhero: medium-dark skin tone
🦸🏿		superhero: dark skin tone
🦸‍♂️		man superhero
🦸🏻‍♂️		man superhero: light skin tone
🦸🏼‍♂️		man superhero: medium-light skin tone
🦸🏽‍♂️		man superhero: medium skin tone
🦸🏾‍♂️		man superhero: medium-dark skin tone
🦸🏿‍♂️		man superhero: dark skin tone
🦸‍♀️		woman superhero
🦸🏻‍♀️		woman superhero: light skin tone
🦸🏼‍♀️		woman superhero: medium-light skin tone
🦸🏽‍♀️		woman superhero: medium skin tone
🦸🏾‍♀️		woman superhero: medium-dark skin tone
🦸🏿‍♀️		woman superhero: dark skin tone
🦹	personaje de supervillano	supervillain
🦹🏻		supervillain: light skin tone
🦹🏼		supervillain: medium-light skin tone
🦹🏽		supervillain: medium skin tone
🦹🏾		supervillain: medium-dark skin tone
🦹🏿		supervillain: dark skin tone
🦹‍♂️		man supervillain
🦹🏻‍♂️		man supervillain: light skin tone
🦹🏼‍♂️		man supervillain: medium-light skin tone
🦹🏽‍♂️		man supervillain: medium skin tone
🦹🏾‍♂️		man supervillain: medium-dark skin tone
🦹🏿‍♂️		man supervillain: dark skin tone
🦹‍♀️		woman supervillain
🦹🏻‍♀️		woman supervillain: light skin tone
🦹🏼‍♀️		woman supervillain: medium-light skin tone
🦹🏽‍♀️		woman supervillain: medium skin tone
🦹🏾‍♀️		woman supervillain: medium-dark skin tone
🦹🏿‍♀️		woman supervillain: dark skin tone
🧙	persona maga	mage
🧙🏻		mage: light skin tone
🧙🏼		mage: medium-light skin tone
🧙🏽		mage: medium skin tone
🧙🏾		mage: medium-dark skin tone
🧙🏿		mage: dark skin tone
🧙‍♂️		man mage
🧙🏻‍♂️		man mage: light skin tone
🧙🏼‍♂️		man mage: medium-light skin tone
🧙🏽‍♂️		man mage: medium skin tone
🧙🏾‍♂️		man mage: medium-dark skin tone
🧙🏿‍♂️		man mage: dark skin tone
🧙‍♀️		woman mage
🧙🏻‍♀️		woman mage: light skin tone
🧙🏼‍♀️		woman mage: medium-light skin tone
🧙🏽‍♀️		woman mage: medium skin tone
🧙🏾‍♀️		woman mage: medium-dark skin tone
🧙🏿‍♀️		woman mage: dark skin tone
🧚	hada	fairy
🧚🏻		fairy: light skin tone
🧚🏼		fairy: medium-light skin tone
🧚🏽		fairy: medium skin tone
🧚🏾		fairy: medium-dark skin tone
🧚🏿		fairy: dark skin tone
🧚‍♂️		man fairy
🧚🏻‍♂️		man fairy: light skin tone
🧚🏼‍♂️		man fairy: medium-light skin tone
🧚🏽‍♂️		man fairy: medium skin tone
🧚🏾‍♂️		man fairy: medium-dark skin tone
🧚🏿‍♂️		man fairy: dark skin tone
🧚‍♀️		woman fairy
🧚🏻‍♀️		woman fairy: light skin tone
🧚🏼‍♀️		woman fairy: medium-light skin tone
🧚🏽‍♀️		woman fairy: medium skin tone
🧚🏾‍♀️		woman fairy: medium-dark skin tone
🧚🏿‍♀️		woman fairy: dark skin tone
🧛	vampiro	vampire
🧛🏻		vampire: light skin tone
🧛🏼		vampire: medium-light skin tone
🧛🏽		vampire: medium skin tone
🧛🏾		vampire: medium-dark skin tone
🧛🏿		vampire: dark skin tone
🧛‍♂️		man vampire
🧛🏻‍♂️		man vampire: light skin tone
🧛🏼‍♂️		man vampire: medium-light skin tone
🧛🏽‍♂️		man vampire: medium skin tone
🧛🏾‍♂️		man vampire: medium-dark skin tone
🧛🏿‍♂️		man vampire: dark skin tone
🧛‍♀️		woman vampire
🧛🏻‍♀️		woman vampire: light skin tone
🧛🏼‍♀️		woman vampire: medium-light skin tone
🧛🏽‍♀️		woman vampire: medium skin tone
🧛🏾‍♀️		woman vampire: medium-dark skin tone
🧛🏿‍♀️		woman vampire: dark skin tone
🧜	persona sirena	merperson
🧜🏻		merperson: light skin tone
🧜🏼		merperson: medium-light skin tone
🧜🏽		merperson: medium skin tone
🧜🏾		merperson: medium-dark skin tone
🧜🏿		merperson: dark skin tone
🧜‍♂️		merman
🧜🏻‍♂️		merman: light skin tone
🧜🏼‍♂️		merman: medium-light skin tone
🧜🏽‍♂️		merman: medium skin tone
🧜🏾‍♂️		merman: medium-dark skin tone
🧜🏿‍♂️		merman: dark skin tone
🧜‍♀️		mermaid
🧜🏻‍♀️		mermaid: light skin tone
🧜🏼‍♀️		mermaid: medium-light skin tone
🧜🏽‍♀️		mermaid: medium skin tone
🧜🏾‍♀️		mermaid: medium-dark skin tone
🧜🏿‍♀️		mermaid: dark skin tone
🧝	elfo	elf
🧝🏻		elf: light skin tone
🧝🏼		elf: medium-light skin tone
🧝🏽		elf: medium skin tone
🧝🏾		elf: medium-dark skin tone
🧝🏿		elf: dark skin tone
🧝‍♂️		man elf
🧝🏻‍♂️		man elf: light skin tone
🧝🏼‍♂️		man elf: medium-light skin tone
🧝🏽‍♂️		man elf: medium skin tone
🧝🏾‍♂️		man elf: medium-dark skin tone
🧝🏿‍♂️		man elf: dark skin tone
🧝‍♀️		woman elf
🧝🏻‍♀️		woman elf: light skin tone
🧝🏼‍♀️		woman elf: medium-light skin tone
🧝🏽‍♀️		woman elf: medium skin tone
🧝🏾‍♀️		woman elf: medium-dark skin tone
🧝🏿‍♀️		woman elf: dark skin tone
🧞	genio	genie
🧞‍♂️		man genie
🧞‍♀️		woman genie
🧟	zombi	zombie
🧟‍♂️		man zombie
🧟‍♀️		woman zombie
🧌	trol	troll
💆	persona recibiendo masaje	person getting massage
💆🏻		person getting massage: light skin tone
💆🏼		person getting massage: medium-light skin tone
💆🏽		person getting massage: medium skin tone
💆🏾		person getting massage: medium-dark skin tone
💆🏿		person getting massage: dark skin tone
💆‍♂️		man getting massage
💆🏻‍♂️		man getting massage: light skin tone
💆🏼‍♂️		man getting massage: medium-light skin tone
💆🏽‍♂️		man getting massage: medium skin tone
💆🏾‍♂️		man getting massage: medium-dark skin tone
💆🏿‍♂️		man getting massage: dark skin tone
💆‍♀️		woman getting massage
💆🏻‍♀️		woman getting massage: light skin tone
💆🏼‍♀️		woman getting massage: medium-light skin tone
💆🏽‍♀️		woman getting massage: medium skin tone
💆🏾‍♀️		woman getting massage: medium-dark skin tone
💆🏿‍♀️		woman getting massage: dark skin tone
💇	persona cortándose el pelo	person getting haircut
💇🏻		person getting haircut: light skin tone
💇🏼		person getting haircut: medium-light skin tone
💇🏽		person getting haircut: medium skin tone
💇🏾		person getting haircut: medium-dark skin tone
💇🏿		person getting haircut: dark skin tone
💇‍♂️		man getting haircut
💇🏻‍♂️		man getting haircut: light skin tone
💇🏼‍♂️		man getting haircut: medium-light skin tone
💇🏽‍♂️		man getting haircut: medium skin tone
💇🏾‍♂️		man getting haircut: medium-dark skin tone
💇🏿‍♂️		man getting haircut: dark skin tone
💇‍♀️		woman getting haircut
💇🏻‍♀️		woman getting haircut: light skin tone
💇🏼‍♀️		woman getting haircut: medium-light skin tone
💇🏽‍♀️		woman getting haircut: medium skin tone
💇🏾‍♀️		woman getting haircut: medium-dark skin tone
💇🏿‍♀️		woman getting haircut: dark skin tone
🚶	persona caminando	person walking
🚶🏻		person walking: light skin tone
🚶🏼		person walking: medium-light skin tone
🚶🏽		person walking: medium skin tone
🚶🏾		person walking: medium-dark skin tone
🚶🏿		person walking: dark skin tone
🚶‍♂️		man walking
🚶🏻‍♂️		man walking: light skin tone
🚶🏼‍♂️		man walking: medium-light skin tone
🚶🏽‍♂️		man walking: medium skin tone
🚶🏾‍♂️		man walking: medium-dark skin tone
🚶🏿‍♂️		man walking: dark skin tone
🚶‍♀️		woman walking
🚶🏻‍♀️		woman walking: light skin tone
🚶🏼‍♀️		woman walking: medium-light skin tone
🚶🏽‍♀️		woman walking: medium skin tone
🚶🏾‍♀️		woman walking: medium-dark skin tone
🚶🏿‍♀️		woman walking: dark skin tone
🚶‍➡️		person walking facing right
🚶🏻‍➡️		person walking facing right: light skin tone
🚶🏼‍➡️		person walking facing right: medium-light skin tone
🚶🏽‍➡️		person walking facing right: medium skin tone
🚶🏾‍➡️		person walking facing right: medium-dark skin tone
🚶🏿‍➡️		person walking facing right: dark skin tone
🚶‍♀️‍➡️		woman walking facing right
🚶🏻‍♀️‍➡️		woman walking facing right: light skin tone
🚶🏼‍♀️‍➡️		woman walking facing right: medium-light skin tone
🚶🏽‍♀️‍➡️		woman walking facing right: medium skin tone
🚶🏾‍♀️‍➡️		woman walking facing right: medium-dark skin tone
🚶🏿‍♀️‍➡️		woman walking facing right: dark skin tone
🚶‍♂️‍➡️		man walking facing right
🚶🏻‍♂️‍➡️		man walking facing right: light skin tone
🚶🏼‍♂️‍➡️		man walking facing right: medium-light skin tone
🚶🏽‍♂️‍➡️		man walking facing right: medium skin tone
🚶🏾‍♂️‍➡️		man walking facing right: medium-dark skin tone
🚶🏿‍♂️‍➡️		man walking facing right: dark skin tone
🧍	persona de pie	person standing
🧍🏻		person standing: light skin tone
🧍🏼		person standing: medium-light skin tone
🧍🏽		person standing: medium skin tone
🧍🏾		person standing: medium-dark skin tone
🧍🏿		person standing: dark skin tone
🧍‍♂️		man standing
🧍🏻‍♂️		man standing: light skin tone
🧍🏼‍♂️		man standing: medium-light skin tone
🧍🏽‍♂️		man standing: medium skin tone
🧍🏾‍♂️		man standing: medium-dark skin tone
🧍🏿‍♂️		man standing: dark skin tone
🧍‍♀️		woman standing
🧍🏻‍♀️		woman standing: light skin tone
🧍🏼‍♀️		woman standing: medium-light skin tone
🧍🏽‍♀️		woman standing: medium skin tone
🧍🏾‍♀️		woman standing: medium-dark skin tone
🧍🏿‍♀️		woman standing: dark skin tone
🧎	persona de rodillas	person kneeling
🧎🏻		person kneeling: light skin tone
🧎🏼		person kneeling: medium-light skin tone
🧎🏽		person kneeling: medium skin tone
🧎🏾		person kneeling: medium-dark skin tone
🧎🏿		person kneeling: dark skin tone
🧎‍♂️		man kneeling
🧎🏻‍♂️		man kneeling: light skin tone
🧎🏼‍♂️		man kneeling: medium-light skin tone
🧎🏽‍♂️		man kneeling: medium skin tone
🧎🏾‍♂️		man kneeling: medium-dark skin tone
🧎🏿‍♂️		man kneeling: dark skin tone
🧎‍♀️		woman kneeling
🧎🏻‍♀️		woman kneeling: light skin tone
🧎🏼‍♀️		woman kneeling: medium-light skin tone
🧎🏽‍♀️		woman kneeling: medium skin tone
🧎🏾‍♀️		woman kneeling: medium-dark skin tone
🧎🏿‍♀️		woman kneeling: dark skin tone
🧎‍➡️		person kneeling facing right
🧎🏻‍➡️		person kneeling facing right: light skin tone
🧎🏼‍➡️		person kneeling facing right: medium-light skin tone
🧎🏽‍➡️		person kneeling facing right: medium skin tone
🧎🏾‍➡️		person kneeling facing right: medium-dark skin tone
🧎🏿‍➡️		person kneeling facing right: dark skin tone
🧎‍♀️‍➡️		woman kneeling facing right
🧎🏻‍♀️‍➡️		woman kneeling facing right: light skin tone
🧎🏼‍♀️‍➡️		woman kneeling facing right: medium-light skin tone
🧎🏽‍♀️‍➡️		woman kneeling facing right: medium skin tone
🧎🏾‍♀️‍➡️		woman kneeling facing right: medium-dark skin tone
🧎🏿‍♀️‍➡️		woman kneeling facing right: dark skin tone
🧎‍♂️‍➡️		man kneeling facing right
🧎🏻‍♂️‍➡️		man kneeling facing right: light skin tone
🧎🏼‍♂️‍➡️		man kneeling facing right: medium-light skin tone
🧎🏽‍♂️‍➡️		man kneeling facing right: medium skin tone
🧎🏾‍♂️‍➡️		man kneeling facing right: medium-dark skin tone
🧎🏿‍♂️‍➡️		man kneeling facing right: dark skin tone
🧑‍🦯	persona con bastón	person with white cane
🧑🏻‍🦯		person with white cane: light skin tone
🧑🏼‍🦯		person with white cane: medium-light skin tone
🧑🏽‍🦯		person with white cane: medium skin tone
🧑🏾‍🦯		person with white cane: medium-dark skin tone
🧑🏿‍🦯		person with white cane: dark skin tone
🧑‍🦯‍➡️		person with white cane facing right
🧑🏻‍🦯‍➡️		person with white cane facing right: light skin tone
🧑🏼‍🦯‍➡️		person with white cane facing right: medium-light skin tone
🧑🏽‍🦯‍➡️		person with white cane facing right: medium skin tone
🧑🏾‍🦯‍➡️		person with white cane facing right: medium-dark skin tone
🧑🏿‍🦯‍➡️		person with white cane facing right: dark skin tone
👨‍🦯	hombre con bastón	man with white cane
👨🏻‍🦯		man with white cane: light skin tone
👨🏼‍🦯		man with white cane: medium-light skin tone
👨🏽‍🦯		man with white cane: medium skin tone
👨🏾‍🦯		man with white cane: medium-dark skin tone
👨🏿‍🦯		man with white cane: dark skin tone
👨‍🦯‍➡️		man with white cane facing right
👨🏻‍🦯‍➡️		man with white cane facing right: light skin tone
👨🏼‍🦯‍➡️		man with white cane facing right: medium-light skin tone
👨🏽‍🦯‍➡️		man with white cane facing right: medium skin tone
👨🏾‍🦯‍➡️		man with white cane facing right: medium-dark skin tone
👨🏿‍🦯‍➡️		man with white cane facing right: dark skin tone
👩‍🦯	mujer con bastón	woman with white cane
👩🏻‍🦯		woman with white cane: light skin tone
👩🏼‍🦯		woman with white cane: medium-light skin tone
👩🏽‍🦯		woman with white cane: medium skin tone
👩🏾‍🦯		woman with white cane: medium-dark skin tone
👩🏿‍🦯		woman with white cane: dark skin tone
👩‍🦯‍➡️		woman with white cane facing right
👩🏻‍🦯‍➡️		woman with white cane facing right: light skin tone
👩🏼‍🦯‍➡️		woman with white cane facing right: medium-light skin tone
👩🏽‍🦯‍➡️		woman with white cane facing right: medium skin tone
👩🏾‍🦯‍➡️		woman with white cane facing right: medium-dark skin tone
👩🏿‍🦯‍➡️		woman with white cane facing right: dark skin tone
🧑‍🦼	persona en silla de ruedas eléctrica	person in motorized wheelchair
🧑🏻‍🦼		person in motorized wheelchair: light skin tone
🧑🏼‍🦼		person in motorized wheelchair: medium-light skin tone
🧑🏽‍🦼		person in motorized wheelchair: medium skin tone
🧑🏾‍🦼		person in motorized wheelchair: medium-dark skin tone
🧑🏿‍🦼		person in motorized wheelchair: dark skin tone
🧑‍🦼‍➡️		person in motorized wheelchair facing right
🧑🏻‍🦼‍➡️		person in motorized wheelchair facing right: light skin tone
🧑🏼‍🦼‍➡️		person in motorized wheelchair facing right: medium-light skin tone
🧑🏽‍🦼‍➡️		person in motorized wheelchair facing right: medium skin tone
🧑🏾‍🦼‍➡️		person in motorized wheelchair facing right: medium-dark skin tone
🧑🏿‍🦼‍➡️		person in motorized wheelchair facing right: dark skin tone
👨‍🦼	hombre en silla de ruedas eléctrica	man in motorized wheelchair
👨🏻‍🦼		man in motorized wheelchair: light skin tone
👨🏼‍🦼		man in motorized wheelchair: medium-light skin tone
👨🏽‍🦼		man in motorized wheelchair: medium skin tone
👨🏾‍🦼		man in motorized wheelchair: medium-dark skin tone
👨🏿‍🦼		man in motorized wheelchair: dark skin tone
👨‍🦼‍➡️		man in motorized wheelchair facing right
👨🏻‍🦼‍➡️		man in motorized wheelchair facing right: light skin tone
👨🏼‍🦼‍➡️		man in motorized wheelchair facing right: medium-light skin tone
👨🏽‍🦼‍➡️		man in motorized wheelchair facing right: medium skin tone
👨🏾‍🦼‍➡️		man in motorized wheelchair facing right: medium-dark skin tone
👨🏿‍🦼‍➡️		man in motorized wheelchair facing right: dark skin tone
👩‍🦼	mujer en silla de ruedas eléctrica	woman in motorized wheelchair
👩🏻‍🦼		woman in motorized wheelchair: light skin tone
👩🏼‍🦼		woman in motorized wheelchair: medium-light skin tone
👩🏽‍🦼		woman in motorized wheelchair: medium skin tone
👩🏾‍🦼		woman in motorized wheelchair: medium-dark skin tone
👩🏿‍🦼		woman in motorized wheelchair: dark skin tone
👩‍🦼‍➡️		woman in motorized wheelchair facing right
👩🏻‍🦼‍➡️		woman in motorized wheelchair facing right: light skin tone
👩🏼‍🦼‍➡️		woman in motorized wheelchair facing right: medium-light skin tone
👩🏽‍🦼‍➡️		woman in motorized wheelchair facing right: medium skin tone
👩🏾‍🦼‍➡️		woman in motorized wheelchair facing right: medium-dark skin tone
👩🏿‍🦼‍➡️		woman in motorized wheelchair facing right: dark skin tone
🧑‍🦽	persona en silla de ruedas manual	person in manual wheelchair
🧑🏻‍🦽		person in manual wheelchair: light skin tone
🧑🏼‍🦽		person in manual wheelchair: medium-light skin tone
🧑🏽‍🦽		person in manual wheelchair: medium skin tone
🧑🏾‍🦽		person in manual wheelchair: medium-dark skin tone
🧑🏿‍🦽		person in manual wheelchair: dark skin tone
🧑‍🦽‍➡️		person in manual wheelchair facing right
🧑🏻‍🦽‍➡️		person in manual wheelchair facing right: light skin tone
🧑🏼‍🦽‍➡️		person in manual wheelchair facing right: medium-light skin tone
🧑🏽‍🦽‍➡️		person in manual wheelchair facing right: medium skin tone
🧑🏾‍🦽‍➡️		person in manual wheelchair facing right: medium-dark skin tone
🧑🏿‍🦽‍➡️		person in manual wheelchair facing right: dark skin tone
👨‍🦽	hombre en silla de ruedas manual	man in manual wheelchair
👨🏻‍🦽		man in manual wheelchair: light skin tone
👨🏼‍🦽		man in manual wheelchair: medium-light skin tone
👨🏽‍🦽		man in manual wheelchair: medium skin tone
👨🏾‍🦽		man in manual wheelchair: medium-dark skin tone
👨🏿‍🦽		man in manual wheelchair: dark skin tone
👨‍🦽‍➡️		man in manual wheelchair facing right
👨🏻‍🦽‍➡️		man in manual wheelchair facing right: light skin tone
👨🏼‍🦽‍➡️		man in manual wheelchair facing right: medium-light skin tone
👨🏽‍🦽‍➡️		man in manual wheelchair facing right: medium skin tone
👨🏾‍🦽‍➡️		man in manual wheelchair facing right: medium-dark skin tone
👨🏿‍🦽‍➡️		man in manual wheelchair facing right: dark skin tone
👩‍🦽	mujer en silla de ruedas manual	woman in manual wheelchair
👩🏻‍🦽		woman in manual wheelchair: light skin tone
👩🏼‍🦽		woman in manual wheelchair: medium-light skin tone
👩🏽‍🦽		woman in manual wheelchair: medium skin tone
👩🏾‍🦽		woman in manual wheelchair: medium-dark skin tone
👩🏿‍🦽		woman in manual wheelchair: dark skin tone
👩‍🦽‍➡️		woman in manual wheelchair facing right
👩🏻‍🦽‍➡️		woman in manual wheelchair facing right: light skin tone
👩🏼‍🦽‍➡️		woman in manual wheelchair facing right: medium-light skin tone
👩🏽‍🦽‍➡️		woman in manual wheelchair facing right: medium skin tone
👩🏾‍🦽‍➡️		woman in manual wheelchair facing right: medium-dark skin tone
👩🏿‍🦽‍➡️		woman in manual wheelchair facing right: dark skin tone
🏃	persona corriendo	person running
🏃🏻		person running: light skin tone
🏃🏼		person running: medium-light skin tone
🏃🏽		person running: medium skin tone
🏃🏾		person running: medium-dark skin tone
🏃🏿		person running: dark skin tone
🏃‍♂️		man running
🏃🏻‍♂️		man running: light skin tone
🏃🏼‍♂️		man running: medium-light skin tone
🏃🏽‍♂️		man running: medium skin tone
🏃🏾‍♂️		man running: medium-dark skin tone
🏃🏿‍♂️		man running: dark skin tone
🏃‍♀️		woman running
🏃🏻‍♀️		woman running: light skin tone
🏃🏼‍♀️		woman running: medium-light skin tone
🏃🏽‍♀️		woman running: medium skin tone
🏃🏾‍♀️		woman running: medium-dark skin tone
🏃🏿‍♀️		woman running: dark skin tone
🏃‍➡️		person running facing right
🏃🏻‍➡️		person running facing right: light skin tone
🏃🏼‍➡️		person running facing right: medium-light skin tone
🏃🏽‍➡️		person running facing right: medium skin tone
🏃🏾‍➡️		person running facing right: medium-dark skin tone
🏃🏿‍➡️		person running facing right: dark skin tone
🏃‍♀️‍➡️		woman running facing right
🏃🏻‍♀️‍➡️		woman running facing right: light skin tone
🏃🏼‍♀️‍➡️		woman running facing right: medium-light skin tone
🏃🏽‍♀️‍➡️		woman running facing right: medium skin tone
🏃🏾‍♀️‍➡️		woman running facing right: medium-dark skin tone
🏃🏿‍♀️‍➡️		woman running facing right: dark skin tone
🏃‍♂️‍➡️		man running facing right
🏃🏻‍♂️‍➡️		man running facing right: light skin tone
🏃🏼‍♂️‍➡️		man running facing right: medium-light skin tone
🏃🏽‍♂️‍➡️		man running facing right: medium skin tone
🏃🏾‍♂️‍➡️		man running facing right: medium-dark skin tone
🏃🏿‍♂️‍➡️		man running facing right: dark skin tone
💃	mujer bailando	woman dancing
💃🏻		woman dancing: light skin tone
💃🏼		woman dancing: medium-light skin tone
💃🏽		woman dancing: medium skin tone
💃🏾		woman dancing: medium-dark skin tone
💃🏿		woman dancing: dark skin tone
🕺	hombre bailando	man dancing
🕺🏻		man dancing: light skin tone
🕺🏼		man dancing: medium-light skin tone
🕺🏽		man dancing: medium skin tone
🕺🏾		man dancing: medium-dark skin tone
🕺🏿		man dancing: dark skin tone
🕴️		person in suit levitating
🕴🏻		person in suit levitating: light skin tone
🕴🏼		person in suit levitating: medium-light skin tone
🕴🏽		person in suit levitating: medium skin tone
🕴🏾		person in suit levitating: medium-dark skin tone
🕴🏿		person in suit levitating: dark skin tone
👯	personas con orejas de conejo	people with bunny ears
👯‍♂️		men with bunny ears
👯‍♀️		women with bunny ears
🧖	persona en una sauna	person in steamy room
🧖🏻		person in steamy room: light skin tone
🧖🏼		person in steamy room: medium-light skin tone
🧖🏽		person in steamy room: medium skin tone
🧖🏾		person in steamy room: medium-dark skin tone
🧖🏿		person in steamy room: dark skin tone
🧖‍♂️		man in steamy room
🧖🏻‍♂️		man in steamy room: light skin tone
🧖🏼‍♂️		man in steamy room: medium-light skin tone
🧖🏽‍♂️		man in steamy room: medium skin tone
🧖🏾‍♂️		man in steamy room: medium-dark skin tone
🧖🏿‍♂️		man in steamy room: dark skin tone
🧖‍♀️		woman in steamy room
🧖🏻‍♀️		woman in steamy room: light skin tone
🧖🏼‍♀️		woman in steamy room: medium-light skin tone
🧖🏽‍♀️		woman in steamy room: medium skin tone
🧖🏾‍♀️		woman in steamy room: medium-dark skin tone
🧖🏿‍♀️		woman in steamy room: dark skin tone
🧗	persona escalando	person climbing
🧗🏻		person climbing: light skin tone
🧗🏼		person climbing: medium-light skin tone
🧗🏽		person climbing: medium skin tone
🧗🏾		person climbing: medium-dark skin tone
🧗🏿		person climbing: dark skin tone
🧗‍♂️		man climbing
🧗🏻‍♂️		man climbing: light skin tone
🧗🏼‍♂️		man climbing: medium-light skin tone
🧗🏽‍♂️		man climbing: medium skin tone
🧗🏾‍♂️		man climbing: medium-dark skin tone
🧗🏿‍♂️		man climbing: dark skin tone
🧗‍♀️		woman climbing
🧗🏻‍♀️		woman climbing: light skin tone
🧗🏼‍♀️		woman climbing: medium-light skin tone
🧗🏽‍♀️		woman climbing: medium skin tone
🧗🏾‍♀️		woman climbing: medium-dark skin tone
🧗🏿‍♀️		woman climbing: dark skin tone
🤺	persona haciendo esgrima	person fencing
🏇	carrera de caballos	horse racing
🏇🏻		horse racing: light skin tone
🏇🏼		horse racing: medium-light skin tone
🏇🏽		horse racing: medium skin tone
🏇🏾		horse racing: medium-dark skin tone
🏇🏿		horse racing: dark skin tone
⛷️		skier
🏂	practicante de snowboard	snowboarder
🏂🏻		snowboarder: light skin tone
🏂🏼		snowboarder: medium-light skin tone
🏂🏽		snowboarder: medium skin tone
🏂🏾		snowboarder: medium-dark skin tone
🏂🏿		snowboarder: dark skin tone
🏌️		person golfing
🏌🏻		person golfing: light skin tone
🏌🏼		person golfing: medium-light skin tone
🏌🏽		person golfing: medium skin tone
🏌🏾		person golfing: medium-dark skin tone
🏌🏿		person golfing: dark skin tone
🏌️‍♂️		man golfing
🏌🏻‍♂️		man golfing: light skin tone
🏌🏼‍♂️		man golfing: medium-light skin tone
🏌🏽‍♂️		man golfing: medium skin tone
🏌🏾‍♂️		man golfing: medium-dark skin tone
🏌🏿‍♂️		man golfing: dark skin tone
🏌️‍♀️		woman golfing
🏌🏻‍♀️		woman golfing: light skin tone
🏌🏼‍♀️		woman golfing: medium-light skin tone
🏌🏽‍♀️		woman golfing: medium skin tone
🏌🏾‍♀️		woman golfing: medium-dark skin tone
🏌🏿‍♀️		woman golfing: dark skin tone
🏄	persona haciendo surf	person surfing
🏄🏻		person surfing: light skin tone
🏄🏼		person surfing: medium-light skin tone
🏄🏽		person surfing: medium skin tone
🏄🏾		person surfing: medium-dark skin tone
🏄🏿		person surfing: dark skin tone
🏄‍♂️		man surfing
🏄🏻‍♂️		man surfing: light skin tone
🏄🏼‍♂️		man surfing: medium-light skin tone
🏄🏽‍♂️		man surfing: medium skin tone
🏄🏾‍♂️		man surfing: medium-dark skin tone
🏄🏿‍♂️		man surfing: dark skin tone
🏄‍♀️		woman surfing
🏄🏻‍♀️		woman surfing: light skin tone
🏄🏼‍♀️		woman surfing: medium-light skin tone
🏄🏽‍♀️		woman surfing: medium skin tone
🏄🏾‍♀️		woman surfing: medium-dark skin tone
🏄🏿‍♀️		woman surfing: dark skin tone
🚣	persona remando en un bote	person rowing boat
🚣🏻		person rowing boat: light skin tone
🚣🏼		person rowing boat: medium-light skin tone
🚣🏽		person rowing boat: medium skin tone
🚣🏾		person rowing boat: medium-dark skin tone
🚣🏿		person rowing boat: dark skin tone
🚣‍♂️		man rowing boat
🚣🏻‍♂️		man rowing boat: light skin tone
🚣🏼‍♂️		man rowing boat: medium-light skin tone
🚣🏽‍♂️		man rowing boat: medium skin tone
🚣🏾‍♂️		man rowing boat: medium-dark skin tone
🚣🏿‍♂️		man rowing boat: dark skin tone
🚣‍♀️		woman rowing boat
🚣🏻‍♀️		woman rowing boat: light skin tone
🚣🏼‍♀️		woman rowing boat: medium-light skin tone
🚣🏽‍♀️		woman rowing boat: medium skin tone
🚣🏾‍♀️		woman rowing boat: medium-dark skin tone
🚣🏿‍♀️		woman rowing boat: dark skin tone
🏊	persona nadando	person swimming
🏊🏻		person swimming: light skin tone
🏊🏼		person swimming: medium-light skin tone
🏊🏽		person swimming: medium skin tone
🏊🏾		person swimming: medium-dark skin tone
🏊🏿		person swimming: dark skin tone
🏊‍♂️		man swimming
🏊🏻‍♂️		man swimming: light skin tone
🏊🏼‍♂️		man swimming: medium-light skin tone
🏊🏽‍♂️		man swimming: medium skin tone
🏊🏾‍♂️		man swimming: medium-dark skin tone
🏊🏿‍♂️		man swimming: dark skin tone
🏊‍♀️		woman swimming
🏊🏻‍♀️		woman swimming: light skin tone
🏊🏼‍♀️		woman swimming: medium-light skin tone
🏊🏽‍♀️		woman swimming: medium skin tone
🏊🏾‍♀️		woman swimming: medium-dark skin tone
🏊🏿‍♀️		woman swimming: dark skin tone
⛹️		person bouncing ball
⛹🏻		person bouncing ball: light skin tone
⛹🏼		person bouncing ball: medium-light skin tone
⛹🏽		person bouncing ball: medium skin tone
⛹🏾		person bouncing ball: medium-dark skin tone
⛹🏿		person bouncing ball: dark skin tone
⛹️‍♂️		man bouncing ball
⛹🏻‍♂️		man bouncing ball: light skin tone
⛹🏼‍♂️		man bouncing ball: medium-light skin tone
⛹🏽‍♂️		man bouncing ball: medium skin tone
⛹🏾‍♂️		man bouncing ball: medium-dark skin tone
⛹🏿‍♂️		man bouncing ball: dark skin tone
⛹️‍♀️		woman bouncing ball
⛹🏻‍♀️		woman bouncing ball: light skin tone
⛹🏼‍♀️		woman bouncing ball: medium-light skin tone
⛹🏽‍♀️		woman bouncing ball: medium skin tone
⛹🏾‍♀️		woman bouncing ball: medium-dark skin tone
⛹🏿‍♀️		woman bouncing ball: dark skin tone
🏋️		person lifting weights
🏋🏻		person lifting weights: light skin tone
🏋🏼		person lifting weights: medium-light skin tone
🏋🏽		person lifting weights: medium skin tone
🏋🏾		person lifting weights: medium-dark skin tone
🏋🏿		person lifting weights: dark skin tone
🏋️‍♂️		man lifting weights
🏋🏻‍♂️		man lifting weights: light skin tone
🏋🏼‍♂️		man lifting weights: medium-light skin tone
🏋🏽‍♂️		man lifting weights: medium skin tone
🏋🏾‍♂️		man lifting weights: medium-dark skin tone
🏋🏿‍♂️		man lifting weights: dark skin tone
🏋️‍♀️		woman lifting weights
🏋🏻‍♀️		woman lifting weights: light skin tone
🏋🏼‍♀️		woman lifting weights: medium-light skin tone
🏋🏽‍♀️		woman lifting weights: medium skin tone
🏋🏾‍♀️		woman lifting weights: medium-dark skin tone
🏋🏿‍♀️		woman lifting weights: dark skin tone
🚴	persona en bicicleta	person biking
🚴🏻		person biking: light skin tone
🚴🏼		person biking: medium-light skin tone
🚴🏽		person biking: medium skin tone
🚴🏾		person biking: medium-dark skin tone
🚴🏿		person biking: dark skin tone
🚴‍♂️		man biking
🚴🏻‍♂️		man biking: light skin tone
🚴🏼‍♂️		man biking: medium-light skin tone
🚴🏽‍♂️		man biking: medium skin tone
🚴🏾‍♂️		man biking: medium-dark skin tone
🚴🏿‍♂️		man biking: dark skin tone
🚴‍♀️		woman biking
🚴🏻‍♀️		woman biking: light skin tone
🚴🏼‍♀️		woman biking: medium-light skin tone
🚴🏽‍♀️		woman biking: medium skin tone
🚴🏾‍♀️		woman biking: medium-dark skin tone
🚴🏿‍♀️		woman biking: dark skin tone
🚵	persona en bicicleta de montaña	person mountain biking
🚵🏻		person mountain biking: light skin tone
🚵🏼		person mountain biking: medium-light skin tone
🚵🏽		person mountain biking: medium skin tone
🚵🏾		person mountain biking: medium-dark skin tone
🚵🏿		person mountain biking: dark skin tone
🚵‍♂️		man mountain biking
🚵🏻‍♂️		man mountain biking: light skin tone
🚵🏼‍♂️		man mountain biking: medium-light skin tone
🚵🏽‍♂️		man mountain biking: medium skin tone
🚵🏾‍♂️		man mountain biking: medium-dark skin tone
🚵🏿‍♂️		man mountain biking: dark skin tone
🚵‍♀️		woman mountain biking
🚵🏻‍♀️		woman mountain biking: light skin tone
🚵🏼‍♀️		woman mountain biking: medium-light skin tone
🚵🏽‍♀️		woman mountain biking: medium skin tone
🚵🏾‍♀️		woman mountain biking: medium-dark skin tone
🚵🏿‍♀️		woman mountain biking: dark skin tone
🤸	persona haciendo voltereta lateral	person cartwheeling
🤸🏻		person cartwheeling: light skin tone
🤸🏼		person cartwheeling: medium-light skin tone
🤸🏽		person cartwheeling: medium skin tone
🤸🏾		person cartwheeling: medium-dark skin tone
🤸🏿		person cartwheeling: dark skin tone
🤸‍♂️		man cartwheeling
🤸🏻‍♂️		man cartwheeling: light skin tone
🤸🏼‍♂️		man cartwheeling: medium-light skin tone
🤸🏽‍♂️		man cartwheeling: medium skin tone
🤸🏾‍♂️		man cartwheeling: medium-dark skin tone
🤸🏿‍♂️		man cartwheeling: dark skin tone
🤸‍♀️		woman cartwheeling
🤸🏻‍♀️		woman cartwheeling: light skin tone
🤸🏼‍♀️		woman cartwheeling: medium-light skin tone
🤸🏽‍♀️		woman cartwheeling: medium skin tone
🤸🏾‍♀️		woman cartwheeling: medium-dark skin tone
🤸🏿‍♀️		woman cartwheeling: dark skin tone
🤼	personas luchando	people wrestling
🤼‍♂️		men wrestling
🤼‍♀️		women wrestling
🤽	persona jugando al waterpolo	person playing water polo
🤽🏻		person playing water polo: light skin tone
🤽🏼		person playing water polo: medium-light skin tone
🤽🏽		person playing water polo: medium skin tone
🤽🏾		person playing water polo: medium-dark skin tone
🤽🏿		person playing water polo: dark skin tone
🤽‍♂️		man playing water polo
🤽🏻‍♂️		man playing water polo: light skin tone
🤽🏼‍♂️		man playing water polo: medium-light skin tone
🤽🏽‍♂️		man playing water polo: medium skin tone
🤽🏾‍♂️		man playing water polo: medium-dark skin tone
🤽🏿‍♂️		man playing water polo: dark skin tone
🤽‍♀️		woman playing water polo
🤽🏻‍♀️		woman playing water polo: light skin tone
🤽🏼‍♀️		woman playing water polo: medium-light skin tone
🤽🏽‍♀️		woman playing water polo: medium skin tone
🤽🏾‍♀️		woman playing water polo: medium-dark skin tone
🤽🏿‍♀️		woman playing water polo: dark skin tone
🤾	persona jugando al balonmano	person playing handball
🤾🏻		person playing handball: light skin tone
🤾🏼		person playing handball: medium-light skin tone
🤾🏽		person playing handball: medium skin tone
🤾🏾		person playing handball: medium-dark skin tone
🤾🏿		person playing handball: dark skin tone
🤾‍♂️		man playing handball
🤾🏻‍♂️		man playing handball: light skin tone
🤾🏼‍♂️		man playing handball: medium-light skin tone
🤾🏽‍♂️		man playing handball: medium skin tone
🤾🏾‍♂️		man playing handball: medium-dark skin tone
🤾🏿‍♂️		man playing handball: dark skin tone
🤾‍♀️		woman playing handball
🤾🏻‍♀️		woman playing handball: light skin tone
🤾🏼‍♀️		woman playing handball: medium-light skin tone
🤾🏽‍♀️		woman playing handball: medium skin tone
🤾🏾‍♀️		woman playing handball: medium-dark skin tone
🤾🏿‍♀️		woman playing handball: dark skin tone
🤹	persona haciendo malabares	person juggling
🤹🏻		person juggling: light skin tone
🤹🏼		person juggling: medium-light skin tone
🤹🏽		person juggling: medium skin tone
🤹🏾		person juggling: medium-dark skin tone
🤹🏿		person juggling: dark skin tone
🤹‍♂️		man juggling
🤹🏻‍♂️		man juggling: light skin tone
🤹🏼‍♂️		man juggling: medium-light skin tone
🤹🏽‍♂️		man juggling: medium skin tone
🤹🏾‍♂️		man juggling: medium-dark skin tone
🤹🏿‍♂️		man juggling: dark skin tone
🤹‍♀️		woman juggling
🤹🏻‍♀️		woman juggling: light skin tone
🤹🏼‍♀️		woman juggling: medium-light skin tone
🤹🏽‍♀️		woman juggling: medium skin tone
🤹🏾‍♀️		woman juggling: medium-dark skin tone
🤹🏿‍♀️		woman juggling: dark skin tone
🧘	persona en posición de loto	person in lotus position
🧘🏻		person in lotus position: light skin tone
🧘🏼		person in lotus position: medium-light skin tone
🧘🏽		person in lotus position: medium skin tone
🧘🏾		person in lotus position: medium-dark skin tone
🧘🏿		person in lotus position: dark skin tone
🧘‍♂️		man in lotus position
🧘🏻‍♂️		man in lotus position: light skin tone
🧘🏼‍♂️		man in lotus position: medium-light skin tone
🧘🏽‍♂️		man in lotus position: medium skin tone
🧘🏾‍♂️		man in lotus position: medium-dark skin tone
🧘🏿‍♂️		man in lotus position: dark skin tone
🧘‍♀️		woman in lotus position
🧘🏻‍♀️		woman in lotus position: light skin tone
🧘🏼‍♀️		woman in lotus position: medium-light skin tone
🧘🏽‍♀️		woman in lotus position: medium skin tone
🧘🏾‍♀️		woman in lotus position: medium-dark skin tone
🧘🏿‍♀️		woman in lotus position: dark skin tone
🛀	persona en la bañera	person taking bath
🛀🏻		person taking bath: light skin tone
🛀🏼		person taking bath: medium-light skin tone
🛀🏽		person taking bath: medium skin tone
🛀🏾		person taking bath: medium-dark skin tone
🛀🏿		person taking bath: dark skin tone
🛌	persona en la cama	person in bed
🛌🏻		person in bed: light skin tone
🛌🏼		person in bed: medium-light skin tone
🛌🏽		person in bed: medium skin tone
🛌🏾		person in bed: medium-dark skin tone
🛌🏿		person in bed: dark skin tone
🧑‍🤝‍🧑	dos personas de la mano	people holding hands
🧑🏻‍🤝‍🧑🏻		people holding hands: light skin tone
🧑🏻‍🤝‍🧑🏼		people holding hands: light skin tone, medium-light skin tone
🧑🏻‍🤝‍🧑🏽		people holding hands: light skin tone, medium skin tone
🧑🏻‍🤝‍🧑🏾		people holding hands: light skin tone, medium-dark skin tone
🧑🏻‍🤝‍🧑🏿		people holding hands: light skin tone, dark skin tone
🧑🏼‍🤝‍🧑🏻		people holding hands: medium-light skin tone, light skin tone
🧑🏼‍🤝‍🧑🏼		people holding hands: medium-light skin tone
🧑🏼‍🤝‍🧑🏽		people holding hands: medium-light skin tone, medium skin tone
🧑🏼‍🤝‍🧑🏾		people holding hands: medium-light skin tone, medium-dark skin tone
🧑🏼‍🤝‍🧑🏿		people holding hands: medium-light skin tone, dark skin tone
🧑🏽‍🤝‍🧑🏻		people holding hands: medium skin tone, light skin tone
🧑🏽‍🤝‍🧑🏼		people holding hands: medium skin tone, medium-light skin tone
🧑🏽‍🤝‍🧑🏽		people holding hands: medium skin tone
🧑🏽‍🤝‍🧑🏾		people holding hands: medium skin tone, medium-dark skin tone
🧑🏽‍🤝‍🧑🏿		people holding hands: medium skin tone, dark skin tone
🧑🏾‍🤝‍🧑🏻		people holding hands: medium-dark skin tone, light skin tone
🧑🏾‍🤝‍🧑🏼		people holding hands: medium-dark skin tone, medium-light skin tone
🧑🏾‍🤝‍🧑🏽		people holding hands: medium-dark skin tone, medium skin tone
🧑🏾‍🤝‍🧑🏾		people holding hands: medium-dark skin tone
🧑🏾‍🤝‍🧑🏿		people holding hands: medium-dark skin tone, dark skin tone
🧑🏿‍🤝‍🧑🏻		people holding hands: dark skin tone, light skin tone
🧑🏿‍🤝‍🧑🏼		people holding hands: dark skin tone, medium-light skin tone
🧑🏿‍🤝‍🧑🏽		people holding hands: dark skin tone, medium skin tone
🧑🏿‍🤝‍🧑🏾		people holding hands: dark skin tone, medium-dark skin tone
🧑🏿‍🤝‍🧑🏿		people holding hands: dark skin tone
👭	mujeres de la mano	women holding hands
👭🏻		women holding hands: light skin tone
👩🏻‍🤝‍👩🏼		women holding hands: light skin tone, medium-light skin tone
👩🏻‍🤝‍👩🏽		women holding hands: light skin tone, medium skin tone
👩🏻‍🤝‍👩🏾		women holding hands: light skin tone, medium-dark skin tone
👩🏻‍🤝‍👩🏿		women holding hands: light skin tone, dark skin tone
👩🏼‍🤝‍👩🏻		women holding hands: medium-light skin tone, light skin tone
👭🏼		women holding hands: medium-light skin tone
👩🏼‍🤝‍👩🏽		women holding hands: medium-light skin tone, medium skin tone
👩🏼‍🤝‍👩🏾		women holding hands: medium-light skin tone, medium-dark skin tone
👩🏼‍🤝‍👩🏿		women holding hands: medium-light skin tone, dark skin tone
👩🏽‍🤝‍👩🏻		women holding hands: medium skin tone, light skin tone
👩🏽‍🤝‍👩🏼		women holding hands: medium skin tone, medium-light skin tone
👭🏽		women holding hands: medium skin tone
👩🏽‍🤝‍👩🏾		women holding hands: medium skin tone, medium-dark skin tone
👩🏽‍🤝‍👩🏿		women holding hands: medium skin tone, dark skin tone
👩🏾‍🤝‍👩🏻		women holding hands: medium-dark skin tone, light skin tone
👩🏾‍🤝‍👩🏼		women holding hands: medium-dark skin tone, medium-light skin tone
👩🏾‍🤝‍👩🏽		women holding hands: medium-dark skin tone, medium skin tone
👭🏾		women holding hands: medium-dark skin tone
👩🏾‍🤝‍👩🏿		women holding hands: medium-dark skin tone, dark skin tone
👩🏿‍🤝‍👩🏻		women holding hands: dark skin tone, light skin tone
👩🏿‍🤝‍👩🏼		women holding hands: dark skin tone, medium-light skin tone
👩🏿‍🤝‍👩🏽		women holding hands: dark skin tone, medium skin tone
👩🏿‍🤝‍👩🏾		women holding hands: dark skin tone, medium-dark skin tone
👭🏿		women holding hands: dark skin tone
👫	mujer y hombre de la mano	woman and man holding hands
👫🏻		woman and man holding hands: light skin tone
👩🏻‍🤝‍👨🏼		woman and man holding hands: light skin tone, medium-light skin tone
👩🏻‍🤝‍👨🏽		woman and man holding hands: light skin tone, medium skin tone
👩🏻‍🤝‍👨🏾		woman and man holding hands: light skin tone, medium-dark skin tone
👩🏻‍🤝‍👨🏿		woman and man holding hands: light skin tone, dark skin tone
👩🏼‍🤝‍👨🏻		woman and man holding hands: medium-light skin tone, light skin tone
👫🏼		woman and man holding hands: medium-light skin tone
👩🏼‍🤝‍👨🏽		woman and man holding hands: medium-light skin tone, medium skin tone
👩🏼‍🤝‍👨🏾		woman and man holding hands: medium-light skin tone, medium-dark skin tone
👩🏼‍🤝‍👨🏿		woman and man holding hands: medium-light skin tone, dark skin tone
👩🏽‍🤝‍👨🏻		woman and man holding hands: medium skin tone, light skin tone
👩🏽‍🤝‍👨🏼		woman and man holding hands: medium skin tone, medium-light skin tone
👫🏽		woman and man holding hands: medium skin tone
👩🏽‍🤝‍👨🏾		woman and man holding hands: medium skin tone, medium-dark skin tone
👩🏽‍🤝‍👨🏿		woman and man holding hands: medium skin tone, dark skin tone
👩🏾‍🤝‍👨🏻		woman and man holding hands: medium-dark skin tone, light skin tone
👩🏾‍🤝‍👨🏼		woman and man holding hands: medium-dark skin tone, medium-light skin tone
👩🏾‍🤝‍👨🏽		woman and man holding hands: medium-dark skin tone, medium skin tone
👫🏾		woman and man holding hands: medium-dark skin tone
👩🏾‍🤝‍👨🏿		woman and man holding hands: medium-dark skin tone, dark skin tone
👩🏿‍🤝‍👨🏻		woman and man holding hands: dark skin tone, light skin tone
👩🏿‍🤝‍👨🏼		woman and man holding hands: dark skin tone, medium-light skin tone
👩🏿‍🤝‍👨🏽		woman and man holding hands: dark skin tone, medium skin tone
👩🏿‍🤝‍👨🏾		woman and man holding hands: dark skin tone, medium-dark skin tone
👫🏿		woman and man holding hands: dark skin tone
👬	hombres de la mano	men holding hands
👬🏻		men holding hands: light skin tone
👨🏻‍🤝‍👨🏼		men holding hands: light skin tone, medium-light skin tone
👨🏻‍🤝‍👨🏽		men holding hands: light skin tone, medium skin tone
👨🏻‍🤝‍👨🏾		men holding hands: light skin tone, medium-dark skin tone
👨🏻‍🤝‍👨🏿		men holding hands: light skin tone, dark skin tone
👨🏼‍🤝‍👨🏻		men holding hands: medium-light skin tone, light skin tone
👬🏼		men holding hands: medium-light skin tone
👨🏼‍🤝‍👨🏽		men holding hands: medium-light skin tone, medium skin tone
👨🏼‍🤝‍👨🏾		men holding hands: medium-light skin tone, medium-dark skin tone
👨🏼‍🤝‍👨🏿		men holding hands: medium-light skin tone, dark skin tone
👨🏽‍🤝‍👨🏻		men holding hands: medium skin tone, light skin tone
👨🏽‍🤝‍👨🏼		men holding hands: medium skin tone, medium-light skin tone
👬🏽		men holding hands: medium skin tone
👨🏽‍🤝‍👨🏾		men holding hands: medium skin tone, medium-dark skin tone
👨🏽‍🤝‍👨🏿		men holding hands: medium skin tone, dark skin tone
👨🏾‍🤝‍👨🏻		men holding hands: medium-dark skin tone, light skin tone
👨🏾‍🤝‍👨🏼		men holding hands: medium-dark skin tone, medium-light skin tone
👨🏾‍🤝‍👨🏽		men holding hands: medium-dark skin tone, medium skin tone
👬🏾		men holding hands: medium-dark skin tone
👨🏾‍🤝‍👨🏿		men holding hands: medium-dark skin tone, dark skin tone
👨🏿‍🤝‍👨🏻		men holding hands: dark skin tone, light skin tone
👨🏿‍🤝‍👨🏼		men holding hands: dark skin tone, medium-light skin tone
👨🏿‍🤝‍👨🏽		men holding hands: dark skin tone, medium skin tone
👨🏿‍🤝‍👨🏾		men holding hands: dark skin tone, medium-dark skin tone
👬🏿		men holding hands: dark skin tone
💏	beso	kiss
💏🏻		kiss: light skin tone
💏🏼		kiss: medium-light skin tone
💏🏽		kiss: medium skin tone
💏🏾		kiss: medium-dark skin tone
💏🏿		kiss: dark skin tone
🧑🏻‍❤️‍💋‍🧑🏼		kiss: person, person, light skin tone, medium-light skin tone
🧑🏻‍❤️‍💋‍🧑🏽		kiss: person, person, light skin tone, medium skin tone
🧑🏻‍❤️‍💋‍🧑🏾		kiss: person, person, light skin tone, medium-dark skin tone
🧑🏻‍❤️‍💋‍🧑🏿		kiss: person, person, light skin tone, dark skin tone
🧑🏼‍❤️‍💋‍🧑🏻		kiss: person, person, medium-light skin tone, light skin tone
🧑🏼‍❤️‍💋‍🧑🏽		kiss: person, person, medium-light skin tone, medium skin tone
🧑🏼‍❤️‍💋‍🧑🏾		kiss: person, person, medium-light skin tone, medium-dark skin tone
🧑🏼‍❤️‍💋‍🧑🏿		kiss: person, person, medium-light skin tone, dark skin tone
🧑🏽‍❤️‍💋‍🧑🏻		kiss: person, person, medium skin tone, light skin tone
🧑🏽‍❤️‍💋‍🧑🏼		kiss: person, person, medium skin tone, medium-light skin tone
🧑🏽‍❤️‍💋‍🧑🏾		kiss: person, person, medium skin tone, medium-dark skin tone
🧑🏽‍❤️‍💋‍🧑🏿		kiss: person, person, medium skin tone, dark skin tone
🧑🏾‍❤️‍💋‍🧑🏻		kiss: person, person, medium-dark skin tone, light skin tone
🧑🏾‍❤️‍💋‍🧑🏼		kiss: person, person, medium-dark skin tone, medium-light skin tone
🧑🏾‍❤️‍💋‍🧑🏽		kiss: person, person, medium-dark skin tone, medium skin tone
🧑🏾‍❤️‍💋‍🧑🏿		kiss: person, person, medium-dark skin tone, dark skin tone
🧑🏿‍❤️‍💋‍🧑🏻		kiss: person, person, dark skin tone, light skin tone
🧑🏿‍❤️‍💋‍🧑🏼		kiss: person, person, dark skin tone, medium-light skin tone
🧑🏿‍❤️‍💋‍🧑🏽		kiss: person, person, dark skin tone, medium skin tone
🧑🏿‍❤️‍💋‍🧑🏾		kiss: person, person, dark skin tone, medium-dark skin tone
👩‍❤️‍💋‍👨		kiss: woman, man
👩🏻‍❤️‍💋‍👨🏻		kiss: woman, man, light skin tone
👩🏻‍❤️‍💋‍👨🏼		kiss: woman, man, light skin tone, medium-light skin tone
👩🏻‍❤️‍💋‍👨🏽		kiss: woman, man, light skin tone, medium skin tone
👩🏻‍❤️‍💋‍👨🏾		kiss: woman, man, light skin tone, medium-dark skin tone
👩🏻‍❤️‍💋‍👨🏿		kiss: woman, man, light skin tone, dark skin tone
👩🏼‍❤️‍💋‍👨🏻		kiss: woman, man, medium-light skin tone, light skin tone
👩🏼‍❤️‍💋‍👨🏼		kiss: woman, man, medium-light skin tone
👩🏼‍❤️‍💋‍👨🏽		kiss: woman, man, medium-light skin tone, medium skin tone
👩🏼‍❤️‍💋‍👨🏾		kiss: woman, man, medium-light skin tone, medium-dark skin tone
👩🏼‍❤️‍💋‍👨🏿		kiss: woman, man, medium-light skin tone, dark skin tone
👩🏽‍❤️‍💋‍👨🏻		kiss: woman, man, medium skin tone, light skin tone
👩🏽‍❤️‍💋‍👨🏼		kiss: woman, man, medium skin tone, medium-light skin tone
👩🏽‍❤️‍💋‍👨🏽		kiss: woman, man, medium skin tone
👩🏽‍❤️‍💋‍👨🏾		kiss: woman, man, medium skin tone, medium-dark skin tone
👩🏽‍❤️‍💋‍👨🏿		kiss: woman, man, medium skin tone, dark skin tone
👩🏾‍❤️‍💋‍👨🏻		kiss: woman, man, medium-dark skin tone, light skin tone
👩🏾‍❤️‍💋‍👨🏼		kiss: woman, man, medium-dark skin tone, medium-light skin tone
👩🏾‍❤️‍💋‍👨🏽		kiss: woman, man, medium-dark skin tone, medium skin tone
👩🏾‍❤️‍💋‍👨🏾		kiss: woman, man, medium-dark skin tone
👩🏾‍❤️‍💋‍👨🏿		kiss: woman, man, medium-dark skin tone, dark skin tone
👩🏿‍❤️‍💋‍👨🏻		kiss: woman, man, dark skin tone, light skin tone
👩🏿‍❤️‍💋‍👨🏼		kiss: woman, man, dark skin tone, medium-light skin tone
👩🏿‍❤️‍💋‍👨🏽		kiss: woman, man, dark skin tone, medium skin tone
👩🏿‍❤️‍💋‍👨🏾		kiss: woman, man, dark skin tone, medium-dark skin tone
👩🏿‍❤️‍💋‍👨🏿		kiss: woman, man, dark skin tone
👨‍❤️‍💋‍👨		kiss: man, man
👨🏻‍❤️‍💋‍👨🏻		kiss: man, man, light skin tone
👨🏻‍❤️‍💋‍👨🏼		kiss: man, man, light skin tone, medium-light skin tone
👨🏻‍❤️‍💋‍👨🏽		kiss: man, man, light skin tone, medium skin tone
👨🏻‍❤️‍💋‍👨🏾		kiss: man, man, light skin tone, medium-dark skin tone
👨🏻‍❤️‍💋‍👨🏿		kiss: man, man, light skin tone, dark skin tone
👨🏼‍❤️‍💋‍👨🏻		kiss: man, man, medium-light skin tone, light skin tone
👨🏼‍❤️‍💋‍👨🏼		kiss: man, man, medium-light skin tone
👨🏼‍❤️‍💋‍👨🏽		kiss: man, man, medium-light skin tone, medium skin tone
👨🏼‍❤️‍💋‍👨🏾		kiss: man, man, medium-light skin tone, medium-dark skin tone
👨🏼‍❤️‍💋‍👨🏿		kiss: man, man, medium-light skin tone, dark skin tone
👨🏽‍❤️‍💋‍👨🏻		kiss: man, man, medium skin tone, light skin tone
👨🏽‍❤️‍💋‍👨🏼		kiss: man, man, medium skin tone, medium-light skin tone
👨🏽‍❤️‍💋‍👨🏽		kiss: man, man, medium skin tone
👨🏽‍❤️‍💋‍👨🏾		kiss: man, man, medium skin tone, medium-dark skin tone
👨🏽‍❤️‍💋‍👨🏿		kiss: man, man, medium skin tone, dark skin tone
👨🏾‍❤️‍💋‍👨🏻		kiss: man, man, medium-dark skin tone, light skin tone
👨🏾‍❤️‍💋‍👨🏼		kiss: man, man, medium-dark skin tone, medium-light skin tone
👨🏾‍❤️‍💋‍👨🏽		kiss: man, man, medium-dark skin tone, medium skin tone
👨🏾‍❤️‍💋‍👨🏾		kiss: man, man, medium-dark skin tone
👨🏾‍❤️‍💋‍👨🏿		kiss: man, man, medium-dark skin tone, dark skin tone
👨🏿‍❤️‍💋‍👨🏻		kiss: man, man, dark skin tone, light skin tone
👨🏿‍❤️‍💋‍👨🏼		kiss: man, man, dark skin tone, medium-light skin tone
👨🏿‍❤️‍💋‍👨🏽		kiss: man, man, dark skin tone, medium skin tone
👨🏿‍❤️‍💋‍👨🏾		kiss: man, man, dark skin tone, medium-dark skin tone
👨🏿‍❤️‍💋‍👨🏿		kiss: man, man, dark skin tone
👩‍❤️‍💋‍👩		kiss: woman, woman
👩🏻‍❤️‍💋‍👩🏻		kiss: woman, woman, light skin tone
👩🏻‍❤️‍💋‍👩🏼		kiss: woman, woman, light skin tone, medium-light skin tone
👩🏻‍❤️‍💋‍👩🏽		kiss: woman, woman, light skin tone, medium skin tone
👩🏻‍❤️‍💋‍👩🏾		kiss: woman, woman, light skin tone, medium-dark skin tone
👩🏻‍❤️‍💋‍👩🏿		kiss: woman, woman, light skin tone, dark skin tone
👩🏼‍❤️‍💋‍👩🏻		kiss: woman, woman, medium-light skin tone, light skin tone
👩🏼‍❤️‍💋‍👩🏼		kiss: woman, woman, medium-light skin tone
👩🏼‍❤️‍💋‍👩🏽		kiss: woman, woman, medium-light skin tone, medium skin tone
👩🏼‍❤️‍💋‍👩🏾		kiss: woman, woman, medium-light skin tone, medium-dark skin tone
👩🏼‍❤️‍💋‍👩🏿		kiss: woman, woman, medium-light skin tone, dark skin tone
👩🏽‍❤️‍💋‍👩🏻		kiss: woman, woman, medium skin tone, light skin tone
👩🏽‍❤️‍💋‍👩🏼		kiss: woman, woman, medium skin tone, medium-light skin tone
👩🏽‍❤️‍💋‍👩🏽		kiss: woman, woman, medium skin tone
👩🏽‍❤️‍💋‍👩🏾		kiss: woman, woman, medium skin tone, medium-dark skin tone
👩🏽‍❤️‍💋‍👩🏿		kiss: woman, woman, medium skin tone, dark skin tone
👩🏾‍❤️‍💋‍👩🏻		kiss: woman, woman, medium-dark skin tone, light skin tone
👩🏾‍❤️‍💋‍👩🏼		kiss: woman, woman, medium-dark skin tone, medium-light skin tone
👩🏾‍❤️‍💋‍👩🏽		kiss: woman, woman, medium-dark skin tone, medium skin tone
👩🏾‍❤️‍💋‍👩🏾		kiss: woman, woman, medium-dark skin tone
👩🏾‍❤️‍💋‍👩🏿		kiss: woman, woman, medium-dark skin tone, dark skin tone
👩🏿‍❤️‍💋‍👩🏻		kiss: woman, woman, dark skin tone, light skin tone
👩🏿‍❤️‍💋‍👩🏼		kiss: woman, woman, dark skin tone, medium-light skin tone
👩🏿‍❤️‍💋‍👩🏽		kiss: woman, woman, dark skin tone, medium skin tone
👩🏿‍❤️‍💋‍👩🏾		kiss: woman, woman, dark skin tone, medium-dark skin tone
👩🏿‍❤️‍💋‍👩🏿		kiss: woman, woman, dark skin tone
💑	pareja enamorada	couple with heart
💑🏻		couple with heart: light skin tone
💑🏼		couple with heart: medium-light skin tone
💑🏽		couple with heart: medium skin tone
💑🏾		couple with heart: medium-dark skin tone
💑🏿		couple with heart: dark skin tone
🧑🏻‍❤️‍🧑🏼		couple with heart: person, person, light skin tone, medium-light skin tone
🧑🏻‍❤️‍🧑🏽		couple with heart: person, person, light skin tone, medium skin tone
🧑🏻‍❤️‍🧑🏾		couple with heart: person, person, light skin tone, medium-dark skin tone
🧑🏻‍❤️‍🧑🏿		couple with heart: person, person, light skin tone, dark skin tone
🧑🏼‍❤️‍🧑🏻		couple with heart: person, person, medium-light skin tone, light skin tone
🧑🏼‍❤️‍🧑🏽		couple with heart: person, person, medium-light skin tone, medium skin tone
🧑🏼‍❤️‍🧑🏾		couple with heart: person, person, medium-light skin tone, medium-dark skin tone
🧑🏼‍❤️‍🧑🏿		couple with heart: person, person, medium-light skin tone, dark skin tone
🧑🏽‍❤️‍🧑🏻		couple with heart: person, person, medium skin tone, light skin tone
🧑🏽‍❤️‍🧑🏼		couple with heart: person, person, medium skin tone, medium-light skin tone
🧑🏽‍❤️‍🧑🏾		couple with heart: person, person, medium skin tone, medium-dark skin tone
🧑🏽‍❤️‍🧑🏿		couple with heart: person, person, medium skin tone, dark skin tone
🧑🏾‍❤️‍🧑🏻		couple with heart: person, person, medium-dark skin tone, light skin tone
🧑🏾‍❤️‍🧑🏼		couple with heart: person, person, medium-dark skin tone, medium-light skin tone
🧑🏾‍❤️‍🧑🏽		couple with heart: person, person, medium-dark skin tone, medium skin tone
🧑🏾‍❤️‍🧑🏿		couple with heart: person, person, medium-dark skin tone, dark skin tone
🧑🏿‍❤️‍🧑🏻		couple with heart: person, person, dark skin tone, light skin tone
🧑🏿‍❤️‍🧑🏼		couple with heart: person, person, dark skin tone, medium-light skin tone
🧑🏿‍❤️‍🧑🏽		couple with heart: person, person, dark skin tone, medium skin tone
🧑🏿‍❤️‍🧑🏾		couple with heart: person, person, dark skin tone, medium-dark skin tone
👩‍❤️‍👨		couple with heart: woman, man
👩🏻‍❤️‍👨🏻		couple with heart: woman, man, light skin tone
👩🏻‍❤️‍👨🏼		couple with heart: woman, man, light skin tone, medium-light skin tone
👩🏻‍❤️‍👨🏽		couple with heart: woman, man, light skin tone, medium skin tone
👩🏻‍❤️‍👨🏾		couple with heart: woman, man, light skin tone, medium-dark skin tone
👩🏻‍❤️‍👨🏿		couple with heart: woman, man, light skin tone, dark skin tone
👩🏼‍❤️‍👨🏻		couple with heart: woman, man, medium-light skin tone, light skin tone
👩🏼‍❤️‍👨🏼		couple with heart: woman, man, medium-light skin tone
👩🏼‍❤️‍👨🏽		couple with heart: woman, man, medium-light skin tone, medium skin tone
👩🏼‍❤️‍👨🏾		couple with heart: woman, man, medium-light skin tone, medium-dark skin tone
👩🏼‍❤️‍👨🏿		couple with heart: woman, man, medium-light skin tone, dark skin tone
👩🏽‍❤️‍👨🏻		couple with heart: woman, man, medium skin tone, light skin tone
👩🏽‍❤️‍👨🏼		couple with heart: woman, man, medium skin tone, medium-light skin tone
👩🏽‍❤️‍👨🏽		couple with heart: woman, man, medium skin tone
👩🏽‍❤️‍👨🏾		couple with heart: woman, man, medium skin tone, medium-dark skin tone
👩🏽‍❤️‍👨🏿		couple with heart: woman, man, medium skin tone, dark skin tone
👩🏾‍❤️‍👨🏻		couple with heart: woman, man, medium-dark skin tone, light skin tone
👩🏾‍❤️‍👨🏼		couple with heart: woman, man, medium-dark skin tone, medium-light skin tone
👩🏾‍❤️‍👨🏽		couple with heart: woman, man, medium-dark skin tone, medium skin tone
👩🏾‍❤️‍👨🏾		couple with heart: woman, man, medium-dark skin tone
👩🏾‍❤️‍👨🏿		couple with heart: woman, man, medium-dark skin tone, dark skin tone
👩🏿‍❤️‍👨🏻		couple with heart: woman, man, dark skin tone, light skin tone
👩🏿‍❤️‍👨🏼		couple with heart: woman, man, dark skin tone, medium-light skin tone
👩🏿‍❤️‍👨🏽		couple with heart: woman, man, dark skin tone, medium skin tone
👩🏿‍❤️‍👨🏾		couple with heart: woman, man, dark skin tone, medium-dark skin tone
👩🏿‍❤️‍👨🏿		couple with heart: woman, man, dark skin tone
👨‍❤️‍👨		couple with heart: man, man
👨🏻‍❤️‍👨🏻		couple with heart: man, man, light skin tone
👨🏻‍❤️‍👨🏼		couple with heart: man, man, light skin tone, medium-light skin tone
👨🏻‍❤️‍👨🏽		couple with heart: man, man, light skin tone, medium skin tone
👨🏻‍❤️‍👨🏾		couple with heart: man, man, light skin tone, medium-dark skin tone
👨🏻‍❤️‍👨🏿		couple with heart: man, man, light skin tone, dark skin tone
👨🏼‍❤️‍👨🏻		couple with heart: man, man, medium-light skin tone, light skin tone
👨🏼‍❤️‍👨🏼		couple with heart: man, man, medium-light skin tone
👨🏼‍❤️‍👨🏽		couple with heart: man, man, medium-light skin tone, medium skin tone
👨🏼‍❤️‍👨🏾		couple with heart: man, man, medium-light skin tone, medium-dark skin tone
👨🏼‍❤️‍👨🏿		couple with heart: man, man, medium-light skin tone, dark skin tone
👨🏽‍❤️‍👨🏻		couple with heart: man, man, medium skin tone, light skin tone
👨🏽‍❤️‍👨🏼		couple with heart: man, man, medium skin tone, medium-light skin tone
👨🏽‍❤️‍👨🏽		couple with heart: man, man, medium skin tone
👨🏽‍❤️‍👨🏾		couple with heart: man, man, medium skin tone, medium-dark skin tone
👨🏽‍❤️‍👨🏿		couple with heart: man, man, medium skin tone, dark skin tone
👨🏾‍❤️‍👨🏻		couple with heart: man, man, medium-dark skin tone, light skin tone
👨🏾‍❤️‍👨🏼		couple with heart: man, man, medium-dark skin tone, medium-light skin tone
👨🏾‍❤️‍👨🏽		couple with heart: man, man, medium-dark skin tone, medium skin tone
👨🏾‍❤️‍👨🏾		couple with heart: man, man, medium-dark skin tone
👨🏾‍❤️‍👨🏿		couple with heart: man, man, medium-dark skin tone, dark skin tone
👨🏿‍❤️‍👨🏻		couple with heart: man, man, dark skin tone, light skin tone
👨🏿‍❤️‍👨🏼		couple with heart: man, man, dark skin tone, medium-light skin tone
👨🏿‍❤️‍👨🏽		couple with heart: man, man, dark skin tone, medium skin tone
👨🏿‍❤️‍👨🏾		couple with heart: man, man, dark skin tone, medium-dark skin tone
👨🏿‍❤️‍👨🏿		couple with heart: man, man, dark skin tone
👩‍❤️‍👩		couple with heart: woman, woman
👩🏻‍❤️‍👩🏻		couple with heart: woman, woman, light skin tone
👩🏻‍❤️‍👩🏼		couple with heart: woman, woman, light skin tone, medium-light skin tone
👩🏻‍❤️‍👩🏽		couple with heart: woman, woman, light skin tone, medium skin tone
👩🏻‍❤️‍👩🏾		couple with heart: woman, woman, light skin tone, medium-dark skin tone
👩🏻‍❤️‍👩🏿		couple with heart: woman, woman, light skin tone, dark skin tone
👩🏼‍❤️‍👩🏻		couple with heart: woman, woman, medium-light skin tone, light skin tone
👩🏼‍❤️‍👩🏼		couple with heart: woman, woman, medium-light skin tone
👩🏼‍❤️‍👩🏽		couple with heart: woman, woman, medium-light skin tone, medium skin tone
👩🏼‍❤️‍👩🏾		couple with heart: woman, woman, medium-light skin tone, medium-dark skin tone
👩🏼‍❤️‍👩🏿		couple with heart: woman, woman, medium-light skin tone, dark skin tone
👩🏽‍❤️‍👩🏻		couple with heart: woman, woman, medium skin tone, light skin tone
👩🏽‍❤️‍👩🏼		couple with heart: woman, woman, medium skin tone, medium-light skin tone
👩🏽‍❤️‍👩🏽		couple with heart: woman, woman, medium skin tone
👩🏽‍❤️‍👩🏾		couple with heart: woman, woman, medium skin tone, medium-dark skin tone
👩🏽‍❤️‍👩🏿		couple with heart: woman, woman, medium skin tone, dark skin tone
👩🏾‍❤️‍👩🏻		couple with heart: woman, woman, medium-dark skin tone, light skin tone
👩🏾‍❤️‍👩🏼		couple with heart: woman, woman, medium-dark skin tone, medium-light skin tone
👩🏾‍❤️‍👩🏽		couple with heart: woman, woman, medium-dark skin tone, medium skin tone
👩🏾‍❤️‍👩🏾		couple with heart: woman, woman, medium-dark skin tone
👩🏾‍❤️‍👩🏿		couple with heart: woman, woman, medium-dark skin tone, dark skin tone
👩🏿‍❤️‍👩🏻		couple with heart: woman, woman, dark skin tone, light skin tone
👩🏿‍❤️‍👩🏼		couple with heart: woman, woman, dark skin tone, medium-light skin tone
👩🏿‍❤️‍👩🏽		couple with heart: woman, woman, dark skin tone, medium skin tone
👩🏿‍❤️‍👩🏾		couple with heart: woman, woman, dark skin tone, medium-dark skin tone
👩🏿‍❤️‍👩🏿		couple with heart: woman, woman, dark skin tone
👨‍👩‍👦		family: man, woman, boy
👨‍👩‍👧		family: man, woman, girl
👨‍👩‍👧‍👦		family: man, woman, girl, boy
👨‍👩‍👦‍👦		family: man, woman, boy, boy
👨‍👩‍👧‍👧		family: man, woman, girl, girl
👨‍👨‍👦		family: man, man, boy
👨‍👨‍👧		family: man, man, girl
👨‍👨‍👧‍👦		family: man, man, girl, boy
👨‍👨‍👦‍👦		family: man, man, boy, boy
👨‍👨‍👧‍👧		family: man, man, girl, girl
👩‍👩‍👦		family: woman, woman, boy
👩‍👩‍👧		family: woman, woman, girl
👩‍👩‍👧‍👦		family: woman, woman, girl, boy
👩‍👩‍👦‍👦		family: woman, woman, boy, boy
👩‍👩‍👧‍👧		family: woman, woman, girl, girl
👨‍👦		family: man, boy
👨‍👦‍👦		family: man, boy, boy
👨‍👧		family: man, girl
👨‍👧‍👦		family: man, girl, boy
👨‍👧‍👧		family: man, girl, girl
👩‍👦		family: woman, boy
👩‍👦‍👦		family: woman, boy, boy
👩‍👧		family: woman, girl
👩‍👧‍👦		family: woman, girl, boy
👩‍👧‍👧		family: woman, girl, girl
🗣️		speaking head
👤	silueta de busto	bust in silhouette
👥	dos siluetas de bustos	busts in silhouette
🫂	personas abrazándose	people hugging
👪	familia	family
🧑‍🧑‍🧒	familia: adulto, adulto, niño	family: adult, adult, child
🧑‍🧑‍🧒‍🧒	familia: adulto, adulto, niño, niño	family: adult, adult, child, child
🧑‍🧒	familia: adulto, niño	family: adult, child
🧑‍🧒‍🧒	familia: adulto, niño, niño	family: adult, child, child
👣	huellas de pies	footprints
🐵	cara de mono	monkey face
🐒	mono	monkey
🦍	gorila	gorilla
🦧	orangután	orangutan
🐶	cara de perro	dog face
🐕	perro	dog
🦮	perro guía	guide dog
🐕‍🦺	perro de servicio	service dog
🐩	caniche	poodle
🐺	lobo	wolf
🦊	zorro	fox
🦝	mapache	raccoon
🐱	cara de gato	cat face
🐈	gato	cat
🐈‍⬛	gato negro	black cat
🦁	león	lion
🐯	cara de tigre	tiger face
🐅	tigre	tiger
🐆	leopardo	leopard
🐴	cara de caballo	horse face
🫎	alce	moose
🫏	burro	donkey
🐎	caballo	horse
🦄	unicornio	unicorn
🦓	cebra	zebra
🦌	ciervo	deer
🦬	bisonte	bison
🐮	cara de vaca	cow face
🐂	buey	ox
🐃	búfalo de agua	water buffalo
🐄	vaca	cow
🐷	cara de cerdo	pig face
🐖	cerdo	pig
🐗	jabalí	boar
🐽	nariz de cerdo	pig nose
🐏	carnero	ram
🐑	oveja	ewe
🐐	cabra	goat
🐪	dromedario	camel
🐫	camello	two-hump camel
🦙	llama	llama
🦒	jirafa	giraffe
🐘	elefante	elephant
🦣	mamut	mammoth
🦏	rinoceronte	rhinoceros
🦛	hipopótamo	hippopotamus
🐭	cara de ratón	mouse face
🐁	ratón	mouse
🐀	rata	rat
🐹	hámster	hamster
🐰	cara de conejo	rabbit face
🐇	conejo	rabbit
🐿️		chipmunk
🦫	castor	beaver
🦔	erizo	hedgehog
🦇	murciélago	bat
🐻	oso	bear
🐻‍❄️		polar bear
🐨	koala	koala
🐼	panda	panda
🦥	perezoso	sloth
🦦	nutria	otter
🦨	mofeta	skunk
🦘	canguro	kangaroo
🦡	tejón	badger
🐾	huellas de pezuñas	paw prints
🦃	pavo	turkey
🐔	gallina	chicken
🐓	gallo	rooster
🐣	pollito rompiendo el cascarón	hatching chick
🐤	pollito	baby chick
🐥	pollito de frente	front-facing baby chick
🐦	pájaro	bird
🐧	pingüino	penguin
🕊️		dove
🦅	águila	eagle
🦆	pato	duck
🦢	cisne	swan
🦉	búho	owl
🦤	dodo	dodo
🪶	pluma	feather
🦩	flamenco	flamingo
🦚	pavo real	peacock
🦜	loro	parrot
🪽	ala	wing
🐦‍⬛	pájaro negro	black bird
🪿	oca	goose
🐦‍🔥	fénix	phoenix
🐸	rana	frog
🐊	cocodrilo	crocodile
🐢	tortuga	turtle
🦎	lagarto	lizard
🐍	serpiente	snake
🐲	cara de dragón	dragon face
🐉	dragón	dragon
🦕	saurópodo	sauropod
🦖	t-rex	T-Rex
🐳	ballena soltando un chorro	spouting whale
🐋	ballena	whale
🐬	delfín	dolphin
🦭	foca	seal
🐟	pez	fish
🐠	pez tropical	tropical fish
🐡	pez globo	blowfish
🦈	tiburón	shark
🐙	pulpo	octopus
🐚	caracola	spiral shell
🪸	coral	coral
🪼	medusa	jellyfish
🐌	caracol	snail
🦋	mariposa	butterfly
🐛	bicho	bug
🐜	hormiga	ant
🐝	abeja	honeybee
🪲	escarabajo	beetle
🐞	mariquita	lady beetle
🦗	grillo	cricket
🪳	cucaracha	cockroach
🕷️		spider
🕸️		spider web
🦂	escorpión	scorpion
🦟	mosquito	mosquito
🪰	mosca	fly
🪱	gusano	worm
🦠	microbio	microbe
💐	ramo de flores	bouquet
🌸	flor de cerezo	cherry blossom
💮	flor blanca	white flower
🪷	loto	lotus
🏵️		rosette
🌹	rosa	rose
🥀	flor marchita	wilted flower
🌺	flor de hibisco	hibiscus
🌻	girasol	sunflower
🌼	flor	blossom
🌷	tulipán	tulip
🪻	campanilla	hyacinth
🌱	planta joven	seedling
🪴	planta de maceta	potted plant
🌲	árbol de hoja perenne	evergreen tree
🌳	árbol de hoja caduca	deciduous tree
🌴	palmera	palm tree
🌵	cactus	cactus
🌾	espiga de arroz	sheaf of rice
🌿	hierba	herb
☘️		shamrock
🍀	trébol de cuatro hojas	four leaf clover
🍁	hoja de arce	maple leaf
🍂	hojas caídas	fallen leaf
🍃	hojas revoloteando al viento	leaf fluttering in wind
🪹	nido vacío	empty nest
🪺	nido con huevos	nest with eggs
🍄	champiñón	mushroom
🍇	uvas	grapes
🍈	melón	melon
🍉	sandía	watermelon
🍊	mandarina	tangerine
🍋	limón	lemon
🍋‍🟩	lima	lime
🍌	plátano	banana
🍍	piña	pineapple
🥭	mango	mango
🍎	manzana roja	red apple
🍏	manzana verde	green apple
🍐	pera	pear
🍑	melocotón	peach
🍒	cerezas	cherries
🍓	fresa	strawberry
🫐	arándanos	blueberries
🥝	kiwi	kiwi fruit
🍅	tomate	tomato
🫒	aceituna	olive
🥥	coco	coconut
🥑	aguacate	avocado
🍆	berenjena	eggplant
🥔	patata	potato
🥕	zanahoria	carrot
🌽	espiga de maíz	ear of corn
🌶️		hot pepper
🫑	pimiento	bell pepper
🥒	pepino	cucumber
🥬	verdura de hoja verde	leafy green
🥦	brócoli	broccoli
🧄	ajo	garlic
🧅	cebolla	onion
🥜	cacahuetes	peanuts
🫘	alubias	beans
🌰	castaña	chestnut
🫚	raíz de jengibre	ginger root
🫛	vaina	pea pod
🍄‍🟫	champiñón marrón	brown mushroom
🍞	pan de molde	bread
🥐	cruasán	croissant
🥖	baguete	baguette bread
🫓	pan sin levadura	flatbread
🥨	bretzel	pretzel
🥯	bagel	bagel
🥞	tortitas	pancakes
🧇	gofre	waffle
🧀	cuña de queso	cheese wedge
🍖	carne con hueso	meat on bone
🍗	muslo de pollo	poultry leg
🥩	corte de carne	cut of meat
🥓	beicon	bacon
🍔	hamburguesa	hamburger
🍟	patatas fritas	french fries
🍕	pizza	pizza
🌭	perrito caliente	hot dog
🥪	sándwich	sandwich
🌮	taco	taco
🌯	burrito	burrito
🫔	tamal	tamale
🥙	pan relleno	stuffed flatbread
🧆	falafel	falafel
🥚	huevo	egg
🍳	cocinar	cooking
🥘	paella	shallow pan of food
🍲	olla de comida	pot of food
🫕	fondue	fondue
🥣	cuenco con cuchara	bowl with spoon
🥗	ensalada	green salad
🍿	palomitas	popcorn
🧈	mantequilla	butter
🧂	sal	salt
🥫	comida enlatada	canned food
🍱	caja de bento	bento box
🍘	galleta de arroz	rice cracker
🍙	bola de arroz	rice ball
🍚	arroz cocido	cooked rice
🍛	arroz con curry	curry rice
🍜	tazón de fideos	steaming bowl
🍝	espagueti	spaghetti
🍠	patata asada	roasted sweet potato
🍢	brocheta	oden
🍣	sushi	sushi
🍤	gamba frita	fried shrimp
🍥	pastel de pescado japonés	fish cake with swirl
🥮	pastel de luna	moon cake
🍡	dango	dango
🥟	dumpling	dumpling
🥠	galleta de la fortuna	fortune cookie
🥡	caja para llevar	takeout box
🦀	cangrejo	crab
🦞	bogavante	lobster
🦐	gamba	shrimp
🦑	calamar	squid
🦪	ostra	oyster
🍦	cucurucho de helado	soft ice cream
🍧	granizado hawaiano	shaved ice
🍨	helado	ice cream
🍩	dónut	doughnut
🍪	galleta	cookie
🎂	tarta de cumpleaños	birthday cake
🍰	trozo de tarta	shortcake
🧁	magdalena	cupcake
🥧	pastel	pie
🍫	tableta de chocolate	chocolate bar
🍬	caramelo	candy
🍭	piruleta	lollipop
🍮	flan	custard
🍯	tarro de miel	honey pot
🍼	biberón	baby bottle
🥛	vaso de leche	glass of milk
☕	bebida caliente	hot beverage
🫖	tetera	teapot
🍵	tazón de té	teacup without handle
🍶	sake	sake
🍾	botella descorchada	bottle with popping cork
🍷	copa de vino	wine glass
🍸	copa de cóctel	cocktail glass
🍹	bebida tropical	tropical drink
🍺	jarra de cerveza	beer mug
🍻	jarras de cerveza brindando	clinking beer mugs
🥂	copas brindando	clinking glasses
🥃	vaso de whisky	tumbler glass
🫗	líquido derramándose	pouring liquid
🥤	vaso con pajita	cup with straw
🧋	té de burbujas	bubble tea
🧃	tetrabrik	beverage box
🧉	mate	mate
🧊	cubito de hielo	ice
🥢	palillos	chopsticks
🍽️		fork and knife with plate
🍴	tenedor y cuchillo	fork and knife
🥄	cuchara	spoon
🔪	cuchillo de cocina	kitchen knife
🫙	tarro	jar
🏺	ánfora	amphora
🌍	globo terráqueo mostrando Europa y África	globe showing Europe-Africa
🌎	globo terráqueo mostrando América	globe showing Americas
🌏	globo terráqueo mostrando Asia y Australia	globe showing Asia-Australia
🌐	globo terráqueo con meridianos	globe with meridians
🗺️		world map
🗾	mapa de Japón	map of Japan
🧭	brújula	compass
🏔️		snow-capped mountain
⛰️		mountain
🌋	volcán	volcano
🗻	monte Fuji	mount fuji
🏕️		camping
🏖️		beach with umbrella
🏜️		desert
🏝️		desert island
🏞️		national park
🏟️		stadium
🏛️		classical building
🏗️		building construction
🧱	ladrillo	brick
🪨	piedra	rock
🪵	madera	wood
🛖	cabaña	hut
🏘️		houses
🏚️		derelict house
🏠	casa	house
🏡	casa con jardín	house with garden
🏢	edificio de oficinas	office building
🏣	oficina de correos japonesa	Japanese post office
🏤	oficina de correos europea	post office
🏥	hospital	hospital
🏦	banco	bank
🏨	hotel	hotel
🏩	hotel del amor	love hotel
🏪	tienda 24 horas	convenience store
🏫	colegio	school
🏬	grandes almacenes	department store
🏭	fábrica	factory
🏯	castillo japonés	Japanese castle
🏰	castillo europeo	castle
💒	iglesia celebrando boda	wedding
🗼	Torre de Tokio	Tokyo tower
🗽	Estatua de la Libertad	Statue of Liberty
⛪	iglesia	church
🕌	mezquita	mosque
🛕	templo hindú	hindu temple
🕍	sinagoga	synagogue
⛩️		shinto shrine
🕋	Kaaba	kaaba
⛲	fuente	fountain
⛺	tienda de campaña	tent
🌁	bruma	foggy
🌃	noche estrellada	night with stars
🏙️		cityscape
🌄	amanecer sobre montañas	sunrise over mountains
🌅	amanecer	sunrise
🌆	ciudad al atardecer	cityscape at dusk
🌇	puesta del sol	sunset
🌉	puente de noche	bridge at night
♨️		hot springs
🎠	caballo de tiovivo	carousel horse
🛝	tobogán	playground slide
🎡	noria de feria	ferris wheel
🎢	montaña rusa	roller coaster
💈	poste de barbero	barber pole
🎪	carpa de circo	circus tent
🚂	locomotora de vapor	locomotive
🚃	vagón	railway car
🚄	tren de alta velocidad	high-speed train
🚅	tren bala	bullet train
🚆	tren	train
🚇	metro	metro
🚈	tren ligero	light rail
🚉	estación de tren	station
🚊	tranvía	tram
🚝	monorraíl	monorail
🚞	ferrocarril de montaña	mountain railway
🚋	vagón de tranvía	tram car
🚌	autobús	bus
🚍	autobús próximo	oncoming bus
🚎	trolebús	trolleybus
🚐	minibús	minibus
🚑	ambulancia	ambulance
🚒	coche de bomberos	fire engine
🚓	coche de policía	police car
🚔	coche de policía próximo	oncoming police car
🚕	taxi	taxi
🚖	taxi próximo	oncoming taxi
🚗	coche	automobile
🚘	coche próximo	oncoming automobile
🚙	vehículo deportivo utilitario	sport utility vehicle
🛻	camioneta	pickup truck
🚚	camión de reparto	delivery truck
🚛	camión articulado	articulated lorry
🚜	tractor	tractor
🏎️		racing car
🏍️		motorcycle
🛵	scooter	motor scooter
🦽	silla de ruedas manual	manual wheelchair
🦼	silla de ruedas eléctrica	motorized wheelchair
🛺	mototaxi	auto rickshaw
🚲	bicicleta	bicycle
🛴	patinete	kick scooter
🛹	monopatín	skateboard
🛼	patines	roller skate
🚏	parada de autobús	bus stop
🛣️		motorway
🛤️		railway track
🛢️		oil drum
⛽	surtidor de gasolina	fuel pump
🛞	rueda	wheel
🚨	luces de policía	police car light
🚥	semáforo horizontal	horizontal traffic light
🚦	semáforo	vertical traffic light
🛑	señal de stop	stop sign
🚧	obras	construction
⚓	ancla	anchor
🛟	salvavidas	ring buoy
⛵	velero	sailboat
🛶	canoa	canoe
🚤	lancha motora	speedboat
🛳️		passenger ship
⛴️		ferry
🛥️		motor boat
🚢	barco	ship
✈️		airplane
🛩️		small airplane
🛫	avión despegando	airplane departure
🛬	avión aterrizando	airplane arrival
🪂	paracaídas	parachute
💺	asiento de transporte	seat
🚁	helicóptero	helicopter
🚟	ferrocarril de suspensión	suspension railway
🚠	teleférico de montaña	mountain cableway
🚡	teleférico	aerial tramway
🛰️		satellite
🚀	cohete	rocket
🛸	platillo volante	flying saucer
🛎️		bellhop bell
🧳	equipaje	luggage
⌛	reloj de arena sin tiempo	hourglass done
⏳	reloj de arena con tiempo	hourglass not done
⌚	reloj	watch
⏰	reloj despertador	alarm clock
⏱️		stopwatch
⏲️		timer clock
🕰️		mantelpiece clock
🕛	12 en punto	twelve o’clock
🕧	doce y media	twelve-thirty
🕐	1 en punto	one o’clock
🕜	una y media	one-thirty
🕑	2 en punto	two o’clock
🕝	dos y media	two-thirty
🕒	3 en punto	three o’clock
🕞	tres y media	three-thirty
🕓	4 en punto	four o’clock
🕟	cuatro y media	four-thirty
🕔	5 en punto	five o’clock
🕠	cinco y media	five-thirty
🕕	6 en punto	six o’clock
🕡	seis y media	six-thirty
🕖	7 en punto	seven o’clock
🕢	siete y media	seven-thirty
🕗	8 en punto	eight o’clock
🕣	ocho y media	eight-thirty
🕘	9 en punto	nine o’clock
🕤	nueve y media	nine-thirty
🕙	10 en punto	ten o’clock
🕥	diez y media	ten-thirty
🕚	11 en punto	eleven o’clock
🕦	once y media	eleven-thirty
🌑	luna nueva	new moon
🌒	luna creciente	waxing crescent moon
🌓	luna en cuarto creciente	first quarter moon
🌔	luna gibosa creciente	waxing gibbous moon
🌕	luna llena	full moon
🌖	luna gibosa menguante	waning gibbous moon
🌗	luna en cuarto menguante	last quarter moon
🌘	luna menguante	waning crescent moon
🌙	luna	crescent moon
🌚	luna nueva con cara	new moon face
🌛	luna de cuarto creciente con cara	first quarter moon face
🌜	luna de cuarto menguante con cara	last quarter moon face
🌡️		thermometer
☀️		sun
🌝	luna llena con cara	full moon face
🌞	sol con cara	sun with face
🪐	planeta con anillos	ringed planet
⭐	estrella	star
🌟	estrella brillante	glowing star
🌠	estrella fugaz	shooting star
🌌	Vía Láctea	milky way
☁️		cloud
⛅	sol detrás de una nube	sun behind cloud
⛈️		cloud with lightning and rain
🌤️		sun behind small cloud
🌥️		sun behind large cloud
🌦️		sun behind rain cloud
🌧️		cloud with rain
🌨️		cloud with snow
🌩️		cloud with lightning
🌪️		tornado
🌫️		fog
🌬️		wind face
🌀	ciclón	cyclone
🌈	arcoíris	rainbow
🌂	paraguas cerrado	closed umbrella
☂️		umbrella
☔	paraguas con gotas de lluvia	umbrella with rain drops
⛱️		umbrella on ground
⚡	alto voltaje	high voltage
❄️		snowflake
☃️		snowman
⛄	muñeco de nieve	snowman without snow
☄️		comet
🔥	fuego	fire
💧	gota	droplet
🌊	ola de mar	water wave
🎃	calabaza de Halloween	jack-o-lantern
🎄	árbol de Navidad	Christmas tree
🎆	fuegos artificiales	fireworks
🎇	bengala	sparkler
🧨	petardo	firecracker
✨	chispas	sparkles
🎈	globo	balloon
🎉	cañón de confeti	party popper
🎊	bola de confeti	confetti ball
🎋	árbol de tanabata	tanabata tree
🎍	decoración de pino	pine decoration
🎎	muñecas japonesas	Japanese dolls
🎏	banderín de carpas	carp streamer
🎐	campanilla de viento	wind chime
🎑	ceremonia de contemplación de la luna	moon viewing ceremony
🧧	sobre rojo	red envelope
🎀	lazo	ribbon
🎁	regalo	wrapped gift
🎗️		reminder ribbon
🎟️		admission tickets
🎫	tique	ticket
🎖️		military medal
🏆	trofeo	trophy
🏅	medalla deportiva	sports medal
🥇	medalla de oro	1st place medal
🥈	medalla de plata	2nd place medal
🥉	medalla de bronce	3rd place medal
⚽	balón de fútbol	soccer ball
⚾	béisbol	baseball
🥎	pelota de softball	softball
🏀	balón de baloncesto	basketball
🏐	pelota de voleibol	volleyball
🏈	balón de fútbol americano	american football
🏉	balón de rugby	rugby football
🎾	pelota de tenis	tennis
🥏	disco volador	flying disc
🎳	bolos	bowling
🏏	críquet	cricket game
🏑	hockey sobre hierba	field hockey
🏒	hockey sobre hielo	ice hockey
🥍	lacrosse	lacrosse
🏓	tenis de mesa	ping pong
🏸	bádminton	badminton
🥊	guante de boxeo	boxing glove
🥋	uniforme de artes marciales	martial arts uniform
🥅	portería	goal net
⛳	banderín en hoyo	flag in hole
⛸️		ice skate
🎣	caña de pescar	fishing pole
🤿	máscara de buceo	diving mask
🎽	camiseta sin mangas	running shirt
🎿	esquís	skis
🛷	trineo	sled
🥌	piedra de curling	curling stone
🎯	diana	bullseye
🪀	yoyó	yo-yo
🪁	cometa	kite
🔫	pistola de agua	water pistol
🎱	bola negra de billar	pool 8 ball
🔮	bola de cristal	crystal ball
🪄	varita mágica	magic wand
🎮	mando de videoconsola	video game
🕹️		joystick
🎰	máquina tragaperras	slot machine
🎲	dado	game die
🧩	pieza de puzle	puzzle piece
🧸	osito de peluche	teddy bear
🪅	piñata	piñata
🪩	bola de espejos	mirror ball
🪆	muñeca rusa	nesting dolls
♠️		spade suit
♥️		heart suit
♦️		diamond suit
♣️		club suit
♟️		chess pawn
🃏	comodín	joker
🀄	dragón rojo de mahjong	mahjong red dragon
🎴	cartas de flores	flower playing cards
🎭	máscaras de teatro	performing arts
🖼️		framed picture
🎨	paleta de pintor	artist palette
🧵	hilo	thread
🪡	aguja de coser	sewing needle
🧶	ovillo	yarn
🪢	nudo	knot
👓	gafas	glasses
🕶️		sunglasses
🥽	gafas de protección	goggles
🥼	bata de laboratorio	lab coat
🦺	chaleco de seguridad	safety vest
👔	corbata	necktie
👕	camiseta	t-shirt
👖	vaqueros	jeans
🧣	bufanda	scarf
🧤	guantes	gloves
🧥	abrigo	coat
🧦	calcetines	socks
👗	vestido	dress
👘	kimono	kimono
🥻	sari	sari
🩱	traje de baño de una pieza	one-piece swimsuit
🩲	ropa interior	briefs
🩳	pantalones cortos	shorts
👙	bikini	bikini
👚	ropa de mujer	woman’s clothes
🪭	abanico abierto	folding hand fan
👛	monedero	purse
👜	bolso	handbag
👝	bolso de mano	clutch bag
🛍️		shopping bags
🎒	mochila escolar	backpack
🩴	chancla	thong sandal
👞	zapato de hombre	man’s shoe
👟	zapatilla deportiva	running shoe
🥾	bota de senderismo	hiking boot
🥿	bailarina	flat shoe
👠	zapato de tacón	high-heeled shoe
👡	sandalia de mujer	woman’s sandal
🩰	zapatillas de ballet	ballet shoes
👢	bota de mujer	woman’s boot
🪮	peineta	hair pick
👑	corona	crown
👒	sombrero de mujer	woman’s hat
🎩	sombrero de copa	top hat
🎓	birrete	graduation cap
🧢	gorra con visera	billed cap
🪖	casco militar	military helmet
⛑️		rescue worker’s helmet
📿	rosario	prayer beads
💄	pintalabios	lipstick
💍	anillo	ring
💎	piedra preciosa	gem stone
🔇	altavoz silenciado	muted speaker
🔈	altavoz a volumen bajo	speaker low volume
🔉	altavoz a volumen medio	speaker medium volume
🔊	altavoz a volumen alto	speaker high volume
📢	altavoz de mano	loudspeaker
📣	megáfono	megaphone
📯	corneta de posta	postal horn
🔔	campana	bell
🔕	campana con signo de cancelación	bell with slash
🎼	pentagrama	musical score
🎵	nota musical	musical note
🎶	notas musicales	musical notes
🎙️		studio microphone
🎚️		level slider
🎛️		control knobs
🎤	micrófono	microphone
🎧	auricular	headphone
📻	radio	radio
🎷	saxofón	saxophone
🪗	acordeón	accordion
🎸	guitarra	guitar
🎹	teclado musical	musical keyboard
🎺	trompeta	trumpet
🎻	violín	violin
🪕	banjo	banjo
🥁	tambor	drum
🪘	tamboril	long drum
🪇	maracas	maracas
🪈	flauta	flute
📱	teléfono móvil	mobile phone
📲	móvil con una flecha	mobile phone with arrow
☎️		telephone
📞	auricular de teléfono	telephone receiver
📟	busca	pager
📠	máquina de fax	fax machine
🔋	pila	battery
🪫	batería baja	low battery
🔌	enchufe eléctrico	electric plug
💻	ordenador portátil	laptop
🖥️		desktop computer
🖨️		printer
⌨️		keyboard
🖱️		computer mouse
🖲️		trackball
💽	minidisc	computer disk
💾	disquete	floppy disk
💿	disco óptico	optical disk
📀	disco DVD	dvd
🧮	ábaco	abacus
🎥	cámara de cine	movie camera
🎞️		film frames
📽️		film projector
🎬	claqueta	clapper board
📺	televisión	television
📷	cámara de fotos	camera
📸	cámara con flash	camera with flash
📹	videocámara	video camera
📼	cinta de vídeo	videocassette
🔍	lupa orientada hacia la izquierda	magnifying glass tilted left
🔎	lupa orientada hacia la derecha	magnifying glass tilted right
🕯️		candle
💡	bombilla	light bulb
🔦	linterna	flashlight
🏮	lámpara japonesa	red paper lantern
🪔	lámpara de aceite	diya lamp
📔	cuaderno con tapa decorativa	notebook with decorative cover
📕	libro cerrado	closed book
📖	libro abierto	open book
📗	libro verde	green book
📘	libro azul	blue book
📙	libro naranja	orange book
📚	libros	books
📓	cuaderno	notebook
📒	libro de contabilidad	ledger
📃	página doblada	page with curl
📜	pergamino	scroll
📄	página hacia arriba	page facing up
📰	periódico	newspaper
🗞️		rolled-up newspaper
📑	marcadores	bookmark tabs
🔖	marcapáginas	bookmark
🏷️		label
💰	bolsa de dinero	money bag
🪙	moneda	coin
💴	billete de yen	yen banknote
💵	billete de dólar	dollar banknote
💶	billete de euro	euro banknote
💷	billete de libra	pound banknote
💸	billete con alas	money with wings
💳	tarjeta de crédito	credit card
🧾	recibo	receipt
💹	mercado al alza	chart increasing with yen
✉️		envelope
📧	correo electrónico	e-mail
📨	sobre entrante	incoming envelope
📩	sobre con flecha	envelope with arrow
📤	bandeja de salida	outbox tray
📥	bandeja de entrada	inbox tray
📦	paquete	package
📫	buzón cerrado con la bandera levantada	closed mailbox with raised flag
📪	buzón cerrado con la bandera bajada	closed mailbox with lowered flag
📬	buzón abierto con la bandera levantada	open mailbox with raised flag
📭	buzón abierto con la bandera bajada	open mailbox with lowered flag
📮	buzón	postbox
🗳️		ballot box with ballot
✏️		pencil
✒️		black nib
🖋️		fountain pen
🖊️		pen
🖌️		paintbrush
🖍️		crayon
📝	cuaderno de notas	memo
💼	maletín	briefcase
📁	carpeta de archivos	file folder
📂	carpeta de archivos abierta	open file folder
🗂️		card index dividers
📅	calendario	calendar
📆	calendario recortable	tear-off calendar
🗒️		spiral notepad
🗓️		spiral calendar
📇	organizador de fichas	card index
📈	gráfica de evolución ascendente	chart increasing
📉	gráfica de evolución descendente	chart decreasing
📊	gráfico de barras	bar chart
📋	portapapeles	clipboard
📌	chincheta	pushpin
📍	chincheta redonda	round pushpin
📎	clip	paperclip
🖇️		linked paperclips
📏	regla	straight ruler
📐	escuadra	triangular ruler
✂️		scissors
🗃️		card file box
🗄️		file cabinet
🗑️		wastebasket
🔒	candado cerrado	locked
🔓	candado abierto	unlocked
🔏	candado con pluma estilográfica	locked with pen
🔐	candado cerrado y llave	locked with key
🔑	llave	key
🗝️		old key
🔨	martillo	hammer
🪓	hacha	axe
⛏️		pick
⚒️		hammer and pick
🛠️		hammer and wrench
🗡️		dagger
⚔️		crossed swords
💣	bomba	bomb
🪃	bumerán	boomerang
🏹	arco y flecha	bow and arrow
🛡️		shield
🪚	sierra de carpintería	carpentry saw
🔧	llave inglesa	wrench
🪛	destornillador	screwdriver
🔩	tornillo y tuerca	nut and bolt
⚙️		gear
🗜️		clamp
⚖️		balance scale
🦯	bastón	white cane
🔗	eslabón	link
⛓️‍💥		broken chain
⛓️		chains
🪝	gancho	hook
🧰	caja de herramientas	toolbox
🧲	imán	magnet
🪜	escalera	ladder
⚗️		alembic
🧪	tubo de ensayo	test tube
🧫	placa de petri	petri dish
🧬	adn	dna
🔬	microscopio	microscope
🔭	telescopio	telescope
📡	antena de satélite	satellite antenna
💉	jeringuilla	syringe
🩸	gota de sangre	drop of blood
💊	píldora	pill
🩹	tirita	adhesive bandage
🩼	muleta	crutch
🩺	estetoscopio	stethoscope
🩻	radiografía	x-ray
🚪	puerta	door
🛗	ascensor	elevator
🪞	espejo	mirror
🪟	ventana	window
🛏️		bed
🛋️		couch and lamp
🪑	silla	chair
🚽	inodoro	toilet
🪠	desatascador	plunger
🚿	ducha	shower
🛁	bañera	bathtub
🪤	trampa de ratones	mouse trap
🪒	cuchilla de afeitar	razor
🧴	bote de crema	lotion bottle
🧷	imperdible	safety pin
🧹	escoba	broom
🧺	cesta	basket
🧻	rollo de papel	roll of paper
🪣	cubo	bucket
🧼	jabón	soap
🫧	burbujas	bubbles
🪥	cepillo de dientes	toothbrush
🧽	esponja	sponge
🧯	extintor	fire extinguisher
🛒	carrito de la compra	shopping cart
🚬	cigarrillo	cigarette
⚰️		coffin
🪦	lápida	headstone
⚱️		funeral urn
🧿	ojo turco	nazar amulet
🪬	hamsa	hamsa
🗿	estatua moái	moai
🪧	letrero	placard
🪪	carné de identidad	identification card
🏧	señal de cajero automático	ATM sign
🚮	señal de usar papelera	litter in bin sign
🚰	agua potable	potable water
♿	símbolo de silla de ruedas	wheelchair symbol
🚹	aseo para hombres	men’s room
🚺	señal de aseo para mujeres	women’s room
🚻	señal de aseos	restroom
🚼	señal de bebé	baby symbol
🚾	aseos	water closet
🛂	control de pasaportes	passport control
🛃	aduana	customs
🛄	recogida de equipajes	baggage claim
🛅	consigna	left luggage
⚠️		warning
🚸	niños cruzando	children crossing
⛔	dirección prohibida	no entry
🚫	prohibido	prohibited
🚳	bicicletas prohibidas	no bicycles
🚭	prohibido fumar	no smoking
🚯	prohibido tirar basura	no littering
🚱	agua no potable	non-potable water
🚷	prohibido el paso de peatones	no pedestrians
📵	prohibido el uso de móviles	no mobile phones
🔞	prohibido para menos de 18 años	no one under eighteen
☢️		radioactive
☣️		biohazard
⬆️		up arrow
↗️		up-right arrow
➡️		right arrow
↘️		down-right arrow
⬇️		down arrow
↙️		down-left arrow
⬅️		left arrow
↖️		up-left arrow
↕️		up-down arrow
↔️		left-right arrow
↩️		right arrow curving left
↪️		left arrow curving right
⤴️		right arrow curving up
⤵️		right arrow curving down
🔃	flechas verticales en sentido horario	clockwise vertical arrows
🔄	flechas en sentido antihorario	counterclockwise arrows button
🔙	flecha BACK	BACK arrow
🔚	flecha END	END arrow
🔛	flecha ON!	ON! arrow
🔜	flecha SOON	SOON arrow
🔝	flecha TOP	TOP arrow
🛐	lugar de culto	place of worship
⚛️		atom symbol
🕉️		om
✡️		star of David
☸️		wheel of dharma
☯️		yin yang
✝️		latin cross
☦️		orthodox cross
☪️		star and crescent
☮️		peace symbol
🕎	menorá	menorah
🔯	estrella de seis puntas	dotted six-pointed star
🪯	khanda	khanda
♈	Aries	Aries
♉	Tauro	Taurus
♊	Géminis	Gemini
♋	Cáncer	Cancer
♌	Leo	Leo
♍	Virgo	Virgo
♎	Libra	Libra
♏	Escorpio	Scorpio
♐	Sagitario	Sagittarius
♑	Capricornio	Capricorn
♒	Acuario	Aquarius
♓	Piscis	Pisces
⛎	Ofiuco	Ophiuchus
🔀	reproducción aleatoria	shuffle tracks button
🔁	repetir	repeat button
🔂	repetir una vez	repeat single button
▶️		play button
⏩	avance rápido	fast-forward button
⏭️		next track button
⏯️		play or pause button
◀️		reverse button
⏪	retroceso rápido	fast reverse button
⏮️		last track button
🔼	triángulo hacia arriba	upwards button
⏫	triángulo doble hacia arriba	fast up button
🔽	triángulo hacia abajo	downwards button
⏬	triángulo doble hacia abajo	fast down button
⏸️		pause button
⏹️		stop button
⏺️		record button
⏏️		eject button
🎦	cine	cinema
🔅	brillo bajo	dim button
🔆	brillo alto	bright button
📶	barras de cobertura	antenna bars
🛜	wifi	wireless
📳	modo vibración	vibration mode
📴	teléfono móvil apagado	mobile phone off
♀️		female sign
♂️		male sign
⚧️		transgender symbol
✖️		multiply
➕	más	plus
➖	menos	minus
➗	división	divide
🟰	signo igual grueso	heavy equals sign
♾️		infinity
‼️		double exclamation mark
⁉️		exclamation question mark
❓	interrogación roja	red question mark
❔	interrogación blanca	white question mark
❕	exclamación blanca	white exclamation mark
❗	exclamación roja	red exclamation mark
〰️		wavy dash
💱	cambio de divisas	currency exchange
💲	símbolo de dólar	heavy dollar sign
⚕️		medical symbol
♻️		recycling symbol
⚜️		fleur-de-lis
🔱	emblema de tridente	trident emblem
📛	etiqueta identificativa	name badge
🔰	símbolo japonés para principiante	Japanese symbol for beginner
⭕	círculo rojo hueco	hollow red circle
✅	botón de marca de verificación	check mark button
☑️		check box with check
✔️		check mark
❌	marca de cruz	cross mark
❎	botón con marca de cruz	cross mark button
➰	bucle	curly loop
➿	bucle doble	double curly loop
〽️		part alternation mark
✳️		eight-spoked asterisk
✴️		eight-pointed star
❇️		sparkle
©️		copyright
®️		registered
™️		trade mark
#️⃣		keycap: #
*️⃣		keycap: *
0️⃣		keycap: 0
1️⃣		keycap: 1
2️⃣		keycap: 2
3️⃣		keycap: 3
4️⃣		keycap: 4
5️⃣		keycap: 5
6️⃣		keycap: 6
7️⃣		keycap: 7
8️⃣		keycap: 8
9️⃣		keycap: 9
🔟		keycap: 10
🔠	letras latinas mayúsculas	input latin uppercase
🔡	letras latinas minúsculas	input latin lowercase
🔢	números	input numbers
🔣	símbolos	input symbols
🔤	alfabeto latino	input latin letters
🅰️		A button (blood type)
🆎	grupo sanguíneo AB	AB button (blood type)
🅱️		B button (blood type)
🆑	borrar	CL button
🆒	botón COOL	COOL button
🆓	botón FREE	FREE button
ℹ️		information
🆔	símbolo de identificación	ID button
Ⓜ️		circled M
🆕	botón NEW	NEW button
🆖	botón NG	NG button
🅾️		O button (blood type)
🆗	botón OK	OK button
🅿️		P button
🆘	símbolo de socorro	SOS button
🆙	botón UP!	UP! button
🆚	botón VS	VS button
🈁	ideograma japonés para "aquí"	Japanese “here” button
🈂️		Japanese “service charge” button
🈷️		Japanese “monthly amount” button
🈶	ideograma japonés para "de pago"	Japanese “not free of charge” button
🈯	ideograma japonés para "reservado"	Japanese “reserved” button
🉐	ideograma japonés para "ganga"	Japanese “bargain” button
🈹	ideograma japonés para "descuento"	Japanese “discount” button
🈚	ideograma japonés para "gratis"	Japanese “free of charge” button
🈲	ideograma japonés para "prohibido"	Japanese “prohibited” button
🉑	ideograma japonés para "aceptable"	Japanese “acceptable” button
🈸	ideograma japonés para "aplicación"	Japanese “application” button
🈴	ideograma japonés para "aprobado"	Japanese “passing grade” button
🈳	ideograma japonés para "vacante"	Japanese “vacancy” button
㊗️		Japanese “congratulations” button
㊙️		Japanese “secret” button
🈺	ideograma japonés para "abierto"	Japanese “open for business” button
🈵	ideograma japonés para "completo"	Japanese “no vacancy” button
🔴	círculo rojo	red circle
🟠	círculo naranja	orange circle
🟡	círculo amarillo	yellow circle
🟢	círculo verde	green circle
🔵	círculo azul	blue circle
🟣	círculo morado	purple circle
🟤	círculo marrón	brown circle
⚫	círculo negro	black circle
⚪	círculo blanco	white circle
🟥	cuadrado rojo	red square
🟧	cuadrado naranja	orange square
🟨	cuadrado amarillo	yellow square
🟩	cuadrado verde	green square
🟦	cuadrado azul	blue square
🟪	cuadrado morado	purple square
🟫	cuadrado marrón	brown square
⬛	cuadrado negro grande	black large square
⬜	cuadrado blanco grande	white large square
◼️		black medium square
◻️		white medium square
◾	cuadrado negro mediano-pequeño	black medium-small square
◽	cuadrado blanco mediano-pequeño	white medium-small square
▪️		black small square
▫️		white small square
🔶	rombo naranja grande	large orange diamond
🔷	rombo azul grande	large blue diamond
🔸	rombo naranja pequeño	small orange diamond
🔹	rombo azul pequeño	small blue diamond
🔺	triángulo rojo hacia arriba	red triangle pointed up
🔻	triángulo rojo hacia abajo	red triangle pointed down
💠	rombo con pétalo	diamond with a dot
🔘	botón de opción	radio button
🔳	botón cuadrado con borde blanco	white square button
🔲	botón cuadrado con borde negro	black square button
🏁	bandera de cuadros	chequered flag
🚩	bandera triangular	triangular flag
🎌	banderas cruzadas	crossed flags
🏴	bandera negra	black flag
🏳️		white flag
🏳️‍🌈		rainbow flag
🏳️‍⚧️		transgender flag
🏴‍☠️		pirate flag
🇦🇨		flag: Ascension Island
🇦🇩		flag: Andorra
🇦🇪		flag: United Arab Emirates
🇦🇫		flag: Afghanistan
🇦🇬		flag: Antigua & Barbuda
🇦🇮		flag: Anguilla
🇦🇱		flag: Albania
🇦🇲		flag: Armenia
🇦🇴		flag: Angola
🇦🇶		flag: Antarctica
🇦🇷		flag: Argentina
🇦🇸		flag: American Samoa
🇦🇹		flag: Austria
🇦🇺		flag: Australia
🇦🇼		flag: Aruba
🇦🇽		flag: Åland Islands
🇦🇿		flag: Azerbaijan
🇧🇦		flag: Bosnia & Herzegovina
🇧🇧		flag: Barbados
🇧🇩		flag: Bangladesh
🇧🇪		flag: Belgium
🇧🇫		flag: Burkina Faso
🇧🇬		flag: Bulgaria
🇧🇭		flag: Bahrain
🇧🇮		flag: Burundi
🇧🇯		flag: Benin
🇧🇱		flag: St. Barthélemy
🇧🇲		flag: Bermuda
🇧🇳		flag: Brunei
🇧🇴		flag: Bolivia
🇧🇶		flag: Caribbean Netherlands
🇧🇷		flag: Brazil
🇧🇸		flag: Bahamas
🇧🇹		flag: Bhutan
🇧🇻		flag: Bouvet Island
🇧🇼		flag: Botswana
🇧🇾		flag: Belarus
🇧🇿		flag: Belize
🇨🇦		flag: Canada
🇨🇨		flag: Cocos (Keeling) Islands
🇨🇩		flag: Congo - Kinshasa
🇨🇫		flag: Central African Republic
🇨🇬		flag: Congo - Brazzaville
🇨🇭		flag: Switzerland
🇨🇮		flag: Côte d’Ivoire
🇨🇰		flag: Cook Islands
🇨🇱		flag: Chile
🇨🇲		flag: Cameroon
🇨🇳		flag: China
🇨🇴		flag: Colombia
🇨🇵		flag: Clipperton Island
🇨🇷		flag: Costa Rica
🇨🇺		flag: Cuba
🇨🇻		flag: Cape Verde
🇨🇼		flag: Curaçao
🇨🇽		flag: Christmas Island
🇨🇾		flag: Cyprus
🇨🇿		flag: Czechia
🇩🇪		flag: Germany
🇩🇬		flag: Diego Garcia
🇩🇯		flag: Djibouti
🇩🇰		flag: Denmark
🇩🇲		flag: Dominica
🇩🇴		flag: Dominican Republic
🇩🇿		flag: Algeria
🇪🇦		flag: Ceuta & Melilla
🇪🇨		flag: Ecuador
🇪🇪		flag: Estonia
🇪🇬		flag: Egypt
🇪🇭		flag: Western Sahara
🇪🇷		flag: Eritrea
🇪🇸		flag: Spain
🇪🇹		flag: Ethiopia
🇪🇺		flag: European Union
🇫🇮		flag: Finland
🇫🇯		flag: Fiji
🇫🇰		flag: Falkland Islands
🇫🇲		flag: Micronesia
🇫🇴		flag: Faroe Islands
🇫🇷		flag: France
🇬🇦		flag: Gabon
🇬🇧		flag: United Kingdom
🇬🇩		flag: Grenada
🇬🇪		flag: Georgia
🇬🇫		flag: French Guiana
🇬🇬		flag: Guernsey
🇬🇭		flag: Ghana
🇬🇮		flag: Gibraltar
🇬🇱		flag: Greenland
🇬🇲		flag: Gambia
🇬🇳		flag: Guinea
🇬🇵		flag: Guadeloupe
🇬🇶		flag: Equatorial Guinea
🇬🇷		flag: Greece
🇬🇸		flag: South Georgia & South Sandwich Islands
🇬🇹		flag: Guatemala
🇬🇺		flag: Guam
🇬🇼		flag: Guinea-Bissau
🇬🇾		flag: Guyana
🇭🇰		flag: Hong Kong SAR China
🇭🇲		flag: Heard & McDonald Islands
🇭🇳		flag: Honduras
🇭🇷		flag: Croatia
🇭🇹		flag: Haiti
🇭🇺		flag: Hungary
🇮🇨		flag: Canary Islands
🇮🇩		flag: Indonesia
🇮🇪		flag: Ireland
🇮🇱		flag: Israel
🇮🇲		flag: Isle of Man
🇮🇳		flag: India
🇮🇴		flag: British Indian Ocean Territory
🇮🇶		flag: Iraq
🇮🇷		flag: Iran
🇮🇸		flag: Iceland
🇮🇹		flag: Italy
🇯🇪		flag: Jersey
🇯🇲		flag: Jamaica
🇯🇴		flag: Jordan
🇯🇵		flag: Japan
🇰🇪		flag: Kenya
🇰🇬		flag: Kyrgyzstan
🇰🇭		flag: Cambodia
🇰🇮		flag: Kiribati
🇰🇲		flag: Comoros
🇰🇳		flag: St. Kitts & Nevis
🇰🇵		flag: North Korea
🇰🇷		flag: South Korea
🇰🇼		flag: Kuwait
🇰🇾		flag: Cayman Islands
🇰🇿		flag: Kazakhstan
🇱🇦		flag: Laos
🇱🇧		flag: Lebanon
🇱🇨		flag: St. Lucia
🇱🇮		flag: Liechtenstein
🇱🇰		flag: Sri Lanka
🇱🇷		flag: Liberia
🇱🇸		flag: Lesotho
🇱🇹		flag: Lithuania
🇱🇺		flag: Luxembourg
🇱🇻		flag: Latvia
🇱🇾		flag: Libya
🇲🇦		flag: Morocco
🇲🇨		flag: Monaco
🇲🇩		flag: Moldova
🇲🇪		flag: Montenegro
🇲🇫		flag: St. Martin
🇲🇬		flag: Madagascar
🇲🇭		flag: Marshall Islands
🇲🇰		flag: North Macedonia
🇲🇱		flag: Mali
🇲🇲		flag: Myanmar (Burma)
🇲🇳		flag: Mongolia
🇲🇴		flag: Macao SAR China
🇲🇵		flag: Northern Mariana Islands
🇲🇶		flag: Martinique
🇲🇷		flag: Mauritania
🇲🇸		flag: Montserrat
🇲🇹		flag: Malta
🇲🇺		flag: Mauritius
🇲🇻		flag: Maldives
🇲🇼		flag: Malawi
🇲🇽		flag: Mexico
🇲🇾		flag: Malaysia
🇲🇿		flag: Mozambique
🇳🇦		flag: Namibia
🇳🇨		flag: New Caledonia
🇳🇪		flag: Niger
🇳🇫		flag: Norfolk Island
🇳🇬		flag: Nigeria
🇳🇮		flag: Nicaragua
🇳🇱		flag: Netherlands
🇳🇴		flag: Norway
🇳🇵		flag: Nepal
🇳🇷		flag: Nauru
🇳🇺		flag: Niue
🇳🇿		flag: New Zealand
🇴🇲		flag: Oman
🇵🇦		flag: Panama
🇵🇪		flag: Peru
🇵🇫		flag: French Polynesia
🇵🇬		flag: Papua New Guinea
🇵🇭		flag: Philippines
🇵🇰		flag: Pakistan
🇵🇱		flag: Poland
🇵🇲		flag: St. Pierre & Miquelon
🇵🇳		flag: Pitcairn Islands
🇵🇷		flag: Puerto Rico
🇵🇸		flag: Palestinian Territories
🇵🇹		flag: Portugal
🇵🇼		flag: Palau
🇵🇾		flag: Paraguay
🇶🇦		flag: Qatar
🇷🇪		flag: Réunion
🇷🇴		flag: Romania
🇷🇸		flag: Serbia
🇷🇺		flag: Russia
🇷🇼		flag: Rwanda
🇸🇦		flag: Saudi Arabia
🇸🇧		flag: Solomon Islands
🇸🇨		flag: Seychelles
🇸🇩		flag: Sudan
🇸🇪		flag: Sweden
🇸🇬		flag: Singapore
🇸🇭		flag: St. Helena
🇸🇮		flag: Slovenia
🇸🇯		flag: Svalbard & Jan Mayen
🇸🇰		flag: Slovakia
🇸🇱		flag: Sierra Leone
🇸🇲		flag: San Marino
🇸🇳		flag: Senegal
🇸🇴		flag: Somalia
🇸🇷		flag: Suriname
🇸🇸		flag: South Sudan
🇸🇹		flag: São Tomé & Príncipe
🇸🇻		flag: El Salvador
🇸🇽		flag: Sint Maarten
🇸🇾		flag: Syria
🇸🇿		flag: Eswatini
🇹🇦		flag: Tristan da Cunha
🇹🇨		flag: Turks & Caicos Islands
🇹🇩		flag: Chad
🇹🇫		flag: French Southern Territories
🇹🇬		flag: Togo
🇹🇭		flag: Thailand
🇹🇯		flag: Tajikistan
🇹🇰		flag: Tokelau
🇹🇱		flag: Timor-Leste
🇹🇲		flag: Turkmenistan
🇹🇳		flag: Tunisia
🇹🇴		flag: Tonga
🇹🇷		flag: Türkiye
🇹🇹		flag: Trinidad & Tobago
🇹🇻		flag: Tuvalu
🇹🇼		flag: Taiwan
🇹🇿		flag: Tanzania
🇺🇦		flag: Ukraine
🇺🇬		flag: Uganda
🇺🇲		flag: U.S. Outlying Islands
🇺🇳		flag: United Nations
🇺🇸		flag: United States
🇺🇾		flag: Uruguay
🇺🇿		flag: Uzbekistan
🇻🇦		flag: Vatican City
🇻🇨		flag: St. Vincent & Grenadines
🇻🇪		flag: Venezuela
🇻🇬		flag: British Virgin Islands
🇻🇮		flag: U.S. Virgin Islands
🇻🇳		flag: Vietnam
🇻🇺		flag: Vanuatu
🇼🇫		flag: Wallis & Futuna
🇼🇸		flag: Samoa
🇽🇰		flag: Kosovo
🇾🇪		flag: Yemen
🇾🇹		flag: Mayotte
🇿🇦		flag: South Africa
🇿🇲		flag: Zambia
🇿🇼		flag: Zimbabwe
🏴󠁧󠁢󠁥󠁮󠁧󠁿		flag: England
🏴󠁧󠁢󠁳󠁣󠁴󠁿		flag: Scotland
🏴󠁧󠁢󠁷󠁬󠁳󠁿		flag: Wales
"""

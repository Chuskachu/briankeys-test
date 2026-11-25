import Foundation

// v0.34i: generated from CLDR (the official Unicode names) —
// one line per emoji: emoji <TAB> nombre ES <TAB> name EN.
// Spanish names exist for the common emojis; English covers all.
// v0.35i: a 4th column — the word(s) that summon this emoji in
// the keyboard, the same claiming EmojiData.nameEmoji uses.
enum EmojiNameData {
    static let all: [(emoji: String, es: String, en: String, triggers: String)] = {
        emojiNameRaw.split(separator: "\n").map { line in
            let p = line.split(separator: "\t", omittingEmptySubsequences: false)
            return (String(p[0]),
                    p.count > 1 ? String(p[1]) : "",
                    p.count > 2 ? String(p[2]) : "",
                    p.count > 3 ? String(p[3]) : "")
        }
    }()
}
private let emojiNameRaw = """
😀	cara sonriendo	grinning face	cara, sonriendo, grinning
😃	cara sonriendo con ojos grandes	grinning face with big eyes	ojos, grandes, big
😄	cara sonriendo con ojos sonrientes	grinning face with smiling eyes	sonrientes, abierta, ojo
😁	cara radiante con ojos sonrientes	beaming face with smiling eyes	radiante, beaming
😆	cara sonriendo con los ojos cerrados	grinning squinting face	cerrados, squinting, boca
😅	cara sonriendo con sudor frío	grinning face with sweat	sudor, frío, sweat
🤣	cara revolviéndose de la risa	rolling on the floor laughing	revolviéndose, rolling, floor
😂	cara llorando de risa	face with tears of joy	llorando, tears, felicidad
🙂	cara sonriendo ligeramente	slightly smiling face	ligeramente, slightly
🙃	cara al revés	upside-down face	revés, upside, down
🫠	cara derritiéndose	melting face	derritiéndose, melting, calor
😉	cara guiñando el ojo	winking face	guiñando, winking, guiño
😊	cara feliz con ojos sonrientes	smiling face with smiling eyes	rubor, blush, glad
😇	cara sonriendo con aureola	smiling face with halo	aureola, halo, ángel
🥰	cara sonriendo con corazones	smiling face with hearts	corazones, hearts, adorar
😍	cara sonriendo con ojos de corazón	smiling face with heart-eyes	corazón, bae, kisses
🤩	cara sonriendo con estrellas	star-struck	estrellas, star, struck
😘	cara lanzando un beso	face blowing a kiss	lanzando, beso, blowing
😗	cara besando	kissing face	besando, kissing, date
☺️		smiling face	
😚	cara besando con los ojos cerrados	kissing face with closed eyes	cerrado
😙	cara besando con ojos sonrientes	kissing face with smiling eyes	night
🥲	cara sonriente con lágrima	smiling face with tear	sonriente, agradecido, aliviado
😋	cara saboreando comida	face savoring food	saboreando, comida, savoring
😛	cara sacando la lengua	face with tongue	sacando, lengua, tongue
😜	cara sacando la lengua y guiñando un ojo	winking face with tongue	crazy, epic, joke
🤪	cara de loco	zany face	loco, zany, grande
😝	cara con ojos cerrados y lengua fuera	squinting face with tongue	fuera, sabor, gross
🤑	cara con lengua de dinero	money-mouth face	dinero, money, paid
🤗	cara con manos abrazando	smiling face with open hands	manos, abrazando, hands
🤭	cara con mano sobre la boca	face with hand over mouth	mano, sobre, hand
🫢	cara con ojos abiertos y boca tapada	face with open eyes and hand over mouth	abiertos, tapada, alucinar
🫣	cara tapada con ojo espiando	face with peeking eye	espiando, peeking, espiar
🤫	cara pidiendo silencio	shushing face	pidiendo, silencio, shushing
🤔	cara pensativa	thinking face	pensativa, thinking, duda
🫡	cara saludando	saluting face	saludando, saluting, ejército
🤐	cara con la boca cerrada con cremallera	zipper-mouth face	cerrada, cremallera, zipper
🤨	cara con ceja alzada	face with raised eyebrow	ceja, alzada, raised
😐	cara neutral	neutral face	neutral, inexpresivo, awkward
😑	cara sin expresión	expressionless face	expresión, inexpresión, inexpresiva
😶	cara sin boca	face without mouth	mouthless, mute, silence
🫥	cara con línea de puntos	dotted line face	línea, puntos, dotted
😶‍🌫️		face in clouds	
😏	cara sonriendo con superioridad	smirking face	superioridad, smirking, listillo
😒	cara de desaprobación	unamused face	desaprobación, insatisfacción, rechazo
🙄	cara con ojos en blanco	face with rolling eyes	blanco, frustración, vueltos
😬	cara haciendo una mueca	grimacing face	haciendo, mueca, grimacing
😮‍💨	cara exhalando	face exhaling	exhalando, exhaling, alivio
🤥	cara de mentiroso	lying face	mentiroso, lying, nariz
🫨	cara temblorosa	shaking face	temblorosa, shaking, temblar
🙂‍↔️		head shaking horizontally	
🙂‍↕️		head shaking vertically	
😌	cara de alivio	relieved face	calm, peace, zen
😔	cara desanimada	pensive face	desanimada, pensive, alicaído
😪	cara de sueño	sleepy face	sueño, sleepy, dormir
🤤	cara babeando	drooling face	babeando, drooling, baba
😴	cara durmiendo	sleeping face	durmiendo, dormido, zzz
😷	cara con mascarilla médica	face with medical mask	mascarilla, médica, medical
🤒	cara con termómetro	face with thermometer	termómetro, thermometer, ill
🤕	cara con la cabeza vendada	face with head-bandage	cabeza, vendada, head
🤢	cara de náuseas	nauseated face	náuseas, nauseated, vomitar
🤮	cara vomitando	face vomiting	vomitando, vomiting, barf
🤧	cara estornudando	sneezing face	estornudando, sneezing, estornudar
🥵	cara con calor	hot face	roja, fiebre, golpe
🥶	cara con frío	cold face	congelada, congelado, helado
🥴	cara de grogui	woozy face	grogui, woozy, atontado
😵	cara mareada	face with crossed-out eyes	mareada, crossed, mareo
😵‍💫	cara con ojos en espiral	face with spiral eyes	espiral, spiral, hipnotizado
🤯	cabeza explotando	exploding head	explotando, exploding, explosión
🤠	cara con sombrero de vaquero	cowboy hat face	sombrero, vaquero, cowboy
🥳	cara de fiesta	partying face	fiesta, partying, capirote
🥸	cara disfrazada	disguised face	disfrazada, disguised, careta
😎	cara sonriendo con gafas de sol	smiling face with sunglasses	sunglasses, guay, beach
🤓	cara de empollón	nerd face	empollón, nerd, friki
🧐	cara con monóculo	face with monocle	monóculo, monocle, aristocrático
😕	cara de confusión	confused face	confusión, confuso, befuddled
🫤	cara con boca diagonal	face with diagonal mouth	diagonal, decepción, decepcionado
😟	cara preocupada	worried face	preocupada, worried, preocupación
🙁	cara con el ceño ligeramente fruncido	slightly frowning face	ceño, fruncido, frowning
☹️		frowning face	
😮	cara con la boca abierta	face with open mouth	believe, forgot, sympathy
😯	cara estupefacta	hushed face	estupefacta, hushed, alucinado
😲	cara asombrada	astonished face	asombrada, astonished, asombrado
😳	cara sonrojada	flushed face	sonrojada, flushed, colorado
🥺	cara suplicante	pleading face	suplicante, pleading, implorar
🥹	cara aguantándose las lágrimas	face holding back tears	aguantándose, lágrimas, holding
😦	cara con el ceño fruncido y la boca abierta	frowning face with open mouth	caught, guard, scary
😧	cara angustiada	anguished face	angustiada, anguished, angustia
😨	cara asustada	fearful face	asustada, fearful, asustado
😰	cara con ansiedad y sudor	anxious face with sweat	ansiedad, eek, rushed
😥	cara triste pero aliviada	sad but relieved face	pero, aliviada, but
😢	cara llorando	crying face	
😭	cara llorando fuerte	loudly crying face	fuerte, loudly, bawling
😱	cara gritando de miedo	face screaming in fear	gritando, screaming, pánico
😖	cara de frustración	confounded face	confounded, frustrado, annoyed
😣	cara desesperada	persevering face	desesperada, persevering, desesperación
😞	cara decepcionada	disappointed face	decepcionada, fail
😓	cara con sudor frío	downcast face with sweat	downcast
😩	cara agotada	weary face	agotada, weary, agotado
😫	cara cansada	tired face	cansada
🥱	cara de bostezo	yawning face	bostezo, yawning, aburrido
😤	cara resoplando	face with steam from nose	resoplando, steam, from
😡	cara cabreada	enraged face	cabreada, enraged, enfadado
😠	cara enfadada	angry face	enfadada, histérico
🤬	cara con símbolos en la boca	face with symbols on mouth	símbolos, symbols, maldecir
😈	cara sonriendo con cuernos	smiling face with horns	cuernos, horns, demonio
👿	cara enfadada con cuernos	angry face with horns	diablo, imp, mischievous
💀	calavera	skull	calavera, skull, cuento
☠️		skull and crossbones	
💩	caca con ojos	pile of poo	caca, pile, poo
🤡	cara de payaso	clown face	payaso, clown
👹	demonio japonés oni	ogre	japonés, oni, ogre
👺	demonio japonés tengu	goblin	tengu, goblin, fantasía
👻	fantasma	ghost	fantasma, ghost, criatura
👽	alienígena	alien	alienígena, alien, extraterrestre
👾	monstruo alienígena	alien monster	game, gamer, games
🤖	robot	robot	robot
😺	gato sonriendo	grinning cat	gato, cat, alegre
😸	gato sonriendo con ojos sonrientes	grinning cat with smiling eyes	
😹	gato llorando de risa	cat with tears of joy	
😻	gato sonriendo con ojos de corazón	smiling cat with heart-eyes	
😼	gato haciendo una mueca	cat with wry smile	wry, irónico, ironic
😽	gato besando	kissing cat	cariñoso
🙀	gato asustado	weary cat	
😿	gato llorando	crying cat	pena
😾	gato enfadado	pouting cat	
🙈	mono con los ojos tapados	see-no-evil monkey	mono, tapados, see
🙉	mono con los oídos tapados	hear-no-evil monkey	oídos, hear, ears
🙊	mono con la boca tapada	speak-no-evil monkey	speak, stealth
💌	carta de amor	love letter	carta, letter, correo
💘	corazón con flecha	heart with arrow	flecha, arrow, cupid
💝	corazón con lazo	heart with ribbon	lazo, ribbon, san
💖	corazón brillante	sparkling heart	brillante, sparkling, morning
💗	corazón creciente	growing heart	creciente, growing, latido
💓	corazón latiendo	beating heart	latiendo, beating, cardio
💞	corazones giratorios	revolving hearts	giratorios, revolving, giratorio
💕	dos corazones	two hearts	dos, two, amantes
💟	adorno de corazón	heart decoration	adorno, decoration, hearth
❣️		heart exclamation	
💔	corazón roto	broken heart	roto, broken, partido
❤️‍🔥		heart on fire	
❤️‍🩹		mending heart	
❤️		red heart	
🩷	corazón rosa	pink heart	rosa, pink, bonito
🧡	corazón naranja	orange heart	naranja, orange
💛	corazón amarillo	yellow heart	amarillo, yellow, cardiac
💚	corazón verde	green heart	verde, green
💙	corazón azul	blue heart	azul
🩵	corazón azul claro	light blue heart	claro, light, celeste
💜	corazón morado	purple heart	morado, bestest
🤎	corazón marrón	brown heart	marrón, brown
🖤	corazón negro	black heart	negro, black, wicked
🩶	corazón gris	grey heart	gris, grey, pizarra
🤍	corazón blanco	white heart	
💋	marca de beso	kiss mark	marca, mark, labios
💯	cien puntos	hundred points	cien, hundred, points
💢	símbolo de enfado	anger symbol	symbol
💥	colisión	collision	colisión, collision, bomb
💫	símbolo de mareo	dizzy	estrella, shining, shooting
💦	gotas de sudor	sweat droplets	gotas, droplets, drip
💨	salir corriendo	dashing away	salir, corriendo, dashing
🕳️		hole	
💬	bocadillo de diálogo	speech balloon	bocadillo, diálogo, speech
👁️‍🗨️		eye in speech bubble	
🗨️		left speech bubble	
🗯️		right anger bubble	
💭	bocadillo de pensamiento	thought balloon	pensamiento, thought, burbuja
💤	símbolo de sueño	ZZZ	
👋	mano saludando	waving hand	waving, agitar, saludar
👋🏻		waving hand: light skin tone	
👋🏼		waving hand: medium-light skin tone	
👋🏽		waving hand: medium skin tone	
👋🏾		waving hand: medium-dark skin tone	
👋🏿		waving hand: dark skin tone	
🤚	dorso de la mano	raised back of hand	dorso, levantado, backhand
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
✋	mano levantada	raised hand	levantada, choca, esos
✋🏻		raised hand: light skin tone	
✋🏼		raised hand: medium-light skin tone	
✋🏽		raised hand: medium skin tone	
✋🏾		raised hand: medium-dark skin tone	
✋🏿		raised hand: dark skin tone	
🖖	saludo vulcano	vulcan salute	vulcano, vulcan, spock
🖖🏻		vulcan salute: light skin tone	
🖖🏼		vulcan salute: medium-light skin tone	
🖖🏽		vulcan salute: medium skin tone	
🖖🏾		vulcan salute: medium-dark skin tone	
🖖🏿		vulcan salute: dark skin tone	
🫱	mano hacia la derecha	rightwards hand	hacia, derecha, rightwards
🫱🏻		rightwards hand: light skin tone	
🫱🏼		rightwards hand: medium-light skin tone	
🫱🏽		rightwards hand: medium skin tone	
🫱🏾		rightwards hand: medium-dark skin tone	
🫱🏿		rightwards hand: dark skin tone	
🫲	mano hacia la izquierda	leftwards hand	izquierda, leftwards, left
🫲🏻		leftwards hand: light skin tone	
🫲🏼		leftwards hand: medium-light skin tone	
🫲🏽		leftwards hand: medium skin tone	
🫲🏾		leftwards hand: medium-dark skin tone	
🫲🏿		leftwards hand: dark skin tone	
🫳	mano con la palma hacia abajo	palm down hand	palma, abajo, palm
🫳🏻		palm down hand: light skin tone	
🫳🏼		palm down hand: medium-light skin tone	
🫳🏽		palm down hand: medium skin tone	
🫳🏾		palm down hand: medium-dark skin tone	
🫳🏿		palm down hand: dark skin tone	
🫴	mano con la palma hacia arriba	palm up hand	arriba, acércate, dame
🫴🏻		palm up hand: light skin tone	
🫴🏼		palm up hand: medium-light skin tone	
🫴🏽		palm up hand: medium skin tone	
🫴🏾		palm up hand: medium-dark skin tone	
🫴🏿		palm up hand: dark skin tone	
🫷	mano empujando hacia la izquierda	leftwards pushing hand	empujando, pushing, detener
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
👌	señal de aprobación con la mano	OK hand	señal, aprobación, bet
👌🏻		OK hand: light skin tone	
👌🏼		OK hand: medium-light skin tone	
👌🏽		OK hand: medium skin tone	
👌🏾		OK hand: medium-dark skin tone	
👌🏿		OK hand: dark skin tone	
🤌	dedos juntos apuntando hacia arriba	pinched fingers	dedos, juntos, apuntando
🤌🏻		pinched fingers: light skin tone	
🤌🏼		pinched fingers: medium-light skin tone	
🤌🏽		pinched fingers: medium skin tone	
🤌🏾		pinched fingers: medium-dark skin tone	
🤌🏿		pinched fingers: dark skin tone	
🤏	mano pellizcando	pinching hand	pellizcando, pinching, pellizco
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
🤞	dedos cruzados	crossed fingers	cruzados, cruzar, suerte
🤞🏻		crossed fingers: light skin tone	
🤞🏼		crossed fingers: medium-light skin tone	
🤞🏽		crossed fingers: medium skin tone	
🤞🏾		crossed fingers: medium-dark skin tone	
🤞🏿		crossed fingers: dark skin tone	
🫰	mano con dedo índice y pulgar cruzados	hand with index finger and thumb crossed	dedo, índice, pulgar
🫰🏻		hand with index finger and thumb crossed: light skin tone	
🫰🏼		hand with index finger and thumb crossed: medium-light skin tone	
🫰🏽		hand with index finger and thumb crossed: medium skin tone	
🫰🏾		hand with index finger and thumb crossed: medium-dark skin tone	
🫰🏿		hand with index finger and thumb crossed: dark skin tone	
🤟	gesto de te quiero	love-you gesture	quiero
🤟🏻		love-you gesture: light skin tone	
🤟🏼		love-you gesture: medium-light skin tone	
🤟🏽		love-you gesture: medium skin tone	
🤟🏾		love-you gesture: medium-dark skin tone	
🤟🏿		love-you gesture: dark skin tone	
🤘	mano haciendo el signo de cuernos	sign of the horns	signo, sign, rock
🤘🏻		sign of the horns: light skin tone	
🤘🏼		sign of the horns: medium-light skin tone	
🤘🏽		sign of the horns: medium skin tone	
🤘🏾		sign of the horns: medium-dark skin tone	
🤘🏿		sign of the horns: dark skin tone	
🤙	mano haciendo el gesto de llamar	call me hand	llamar, meñique, hang
🤙🏻		call me hand: light skin tone	
🤙🏼		call me hand: medium-light skin tone	
🤙🏽		call me hand: medium skin tone	
🤙🏾		call me hand: medium-dark skin tone	
🤙🏿		call me hand: dark skin tone	
👈	dorso de mano con índice a la izquierda	backhand index pointing left	pointing
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
👆	dorso de mano con índice hacia arriba	backhand index pointing up	apuntar
👆🏻		backhand index pointing up: light skin tone	
👆🏼		backhand index pointing up: medium-light skin tone	
👆🏽		backhand index pointing up: medium skin tone	
👆🏾		backhand index pointing up: medium-dark skin tone	
👆🏿		backhand index pointing up: dark skin tone	
🖕	dedo corazón hacia arriba	middle finger	middle, peineta
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
🫵	dedo índice apuntándote a ti	index pointing at the viewer	apuntándote, viewer, poke
🫵🏻		index pointing at the viewer: light skin tone	
🫵🏼		index pointing at the viewer: medium-light skin tone	
🫵🏽		index pointing at the viewer: medium skin tone	
🫵🏾		index pointing at the viewer: medium-dark skin tone	
🫵🏿		index pointing at the viewer: dark skin tone	
👍	pulgar hacia arriba	thumbs up	thumbs
👍🏻		thumbs up: light skin tone	
👍🏼		thumbs up: medium-light skin tone	
👍🏽		thumbs up: medium skin tone	
👍🏾		thumbs up: medium-dark skin tone	
👍🏿		thumbs up: dark skin tone	
👎	pulgar hacia abajo	thumbs down	bad, dislike, nope
👎🏻		thumbs down: light skin tone	
👎🏼		thumbs down: medium-light skin tone	
👎🏽		thumbs down: medium skin tone	
👎🏾		thumbs down: medium-dark skin tone	
👎🏿		thumbs down: dark skin tone	
✊	puño en alto	raised fist	puño, alto, fist
✊🏻		raised fist: light skin tone	
✊🏼		raised fist: medium-light skin tone	
✊🏽		raised fist: medium skin tone	
✊🏾		raised fist: medium-dark skin tone	
✊🏿		raised fist: dark skin tone	
👊	puño cerrado	oncoming fist	oncoming, absolutely, bruh
👊🏻		oncoming fist: light skin tone	
👊🏼		oncoming fist: medium-light skin tone	
👊🏽		oncoming fist: medium skin tone	
👊🏾		oncoming fist: medium-dark skin tone	
👊🏿		oncoming fist: dark skin tone	
🤛	puño hacia la izquierda	left-facing fist	facing
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
👏	manos aplaudiendo	clapping hands	aplaudiendo, clapping, aplaudir
👏🏻		clapping hands: light skin tone	
👏🏼		clapping hands: medium-light skin tone	
👏🏽		clapping hands: medium skin tone	
👏🏾		clapping hands: medium-dark skin tone	
👏🏿		clapping hands: dark skin tone	
🙌	manos levantadas celebrando	raising hands	levantadas, celebrando, raising
🙌🏻		raising hands: light skin tone	
🙌🏼		raising hands: medium-light skin tone	
🙌🏽		raising hands: medium skin tone	
🙌🏾		raising hands: medium-dark skin tone	
🙌🏿		raising hands: dark skin tone	
🫶	manos formando un corazón	heart hands	formando
🫶🏻		heart hands: light skin tone	
🫶🏼		heart hands: medium-light skin tone	
🫶🏽		heart hands: medium skin tone	
🫶🏾		heart hands: medium-dark skin tone	
🫶🏿		heart hands: dark skin tone	
👐	manos abiertas	open hands	abiertas, jazz, swerve
👐🏻		open hands: light skin tone	
👐🏼		open hands: medium-light skin tone	
👐🏽		open hands: medium skin tone	
👐🏾		open hands: medium-dark skin tone	
👐🏿		open hands: dark skin tone	
🤲	palmas hacia arriba juntas	palms up together	juntas, palms, together
🤲🏻		palms up together: light skin tone	
🤲🏼		palms up together: medium-light skin tone	
🤲🏽		palms up together: medium skin tone	
🤲🏾		palms up together: medium-dark skin tone	
🤲🏿		palms up together: dark skin tone	
🤝	apretón de manos	handshake	apretón, acuerdo, agreement
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
🙏	manos en oración	folded hands	folded, gracias, orar
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
💅	pintarse las uñas	nail polish	pintarse, uñas, nail
💅🏻		nail polish: light skin tone	
💅🏼		nail polish: medium-light skin tone	
💅🏽		nail polish: medium skin tone	
💅🏾		nail polish: medium-dark skin tone	
💅🏿		nail polish: dark skin tone	
🤳	selfi	selfie	selfi, selfie, autofoto
🤳🏻		selfie: light skin tone	
🤳🏼		selfie: medium-light skin tone	
🤳🏽		selfie: medium skin tone	
🤳🏾		selfie: medium-dark skin tone	
🤳🏿		selfie: dark skin tone	
💪	bíceps flexionado	flexed biceps	bíceps, flexionado, flexed
💪🏻		flexed biceps: light skin tone	
💪🏼		flexed biceps: medium-light skin tone	
💪🏽		flexed biceps: medium skin tone	
💪🏾		flexed biceps: medium-dark skin tone	
💪🏿		flexed biceps: dark skin tone	
🦾	brazo mecánico	mechanical arm	brazo, mecánico, mechanical
🦿	pierna mecánica	mechanical leg	pierna, mecánica, leg
🦵	pierna	leg	extremidad, patada, bent
🦵🏻		leg: light skin tone	
🦵🏼		leg: medium-light skin tone	
🦵🏽		leg: medium skin tone	
🦵🏾		leg: medium-dark skin tone	
🦵🏿		leg: dark skin tone	
🦶	pie	foot	pie, pisotón, ankle
🦶🏻		foot: light skin tone	
🦶🏼		foot: medium-light skin tone	
🦶🏽		foot: medium skin tone	
🦶🏾		foot: medium-dark skin tone	
🦶🏿		foot: dark skin tone	
👂	oreja	ear	oreja, ear, cuerpo
👂🏻		ear: light skin tone	
👂🏼		ear: medium-light skin tone	
👂🏽		ear: medium skin tone	
👂🏾		ear: medium-dark skin tone	
👂🏿		ear: dark skin tone	
🦻	oreja con audífono	ear with hearing aid	audífono, aid, auditiva
🦻🏻		ear with hearing aid: light skin tone	
🦻🏼		ear with hearing aid: medium-light skin tone	
🦻🏽		ear with hearing aid: medium skin tone	
🦻🏾		ear with hearing aid: medium-dark skin tone	
🦻🏿		ear with hearing aid: dark skin tone	
👃	nariz	nose	noses, nosey, odor
👃🏻		nose: light skin tone	
👃🏼		nose: medium-light skin tone	
👃🏽		nose: medium skin tone	
👃🏾		nose: medium-dark skin tone	
👃🏿		nose: dark skin tone	
🧠	cerebro	brain	cerebro, brain, inteligente
🫀	corazón humano	anatomical heart	humano, anatomical, anatomía
🫁	pulmones	lungs	pulmones, lungs, inhalar
🦷	diente	tooth	diente, tooth, dentista
🦴	hueso	bone	hueso, bone, esqueleto
👀	ojos	eyes	googly, look, looking
👁️		eye	
👅	lengua	tongue	lick, slurp
👄	boca	mouth	beauty, lipstick
🫦	labio mordido	biting lip	labio, mordido, biting
👶	bebé	baby	bebé, baby, joven
👶🏻		baby: light skin tone	
👶🏼		baby: medium-light skin tone	
👶🏽		baby: medium skin tone	
👶🏾		baby: medium-dark skin tone	
👶🏿		baby: dark skin tone	
🧒	infante	child	infante, child, crío
🧒🏻		child: light skin tone	
🧒🏼		child: medium-light skin tone	
🧒🏽		child: medium skin tone	
🧒🏾		child: medium-dark skin tone	
🧒🏿		child: dark skin tone	
👦	niño	boy	boy, grandson, son
👦🏻		boy: light skin tone	
👦🏼		boy: medium-light skin tone	
👦🏽		boy: medium skin tone	
👦🏾		boy: medium-dark skin tone	
👦🏿		boy: dark skin tone	
👧	niña	girl	niña, girl, chica
👧🏻		girl: light skin tone	
👧🏼		girl: medium-light skin tone	
👧🏽		girl: medium skin tone	
👧🏾		girl: medium-dark skin tone	
👧🏿		girl: dark skin tone	
🧑	persona adulta	person	persona, adulta, adult
🧑🏻		person: light skin tone	
🧑🏼		person: medium-light skin tone	
🧑🏽		person: medium skin tone	
🧑🏾		person: medium-dark skin tone	
🧑🏿		person: dark skin tone	
👱	persona adulta rubia	person: blond hair	rubia, blond, hair
👱🏻		person: light skin tone, blond hair	
👱🏼		person: medium-light skin tone, blond hair	
👱🏽		person: medium skin tone, blond hair	
👱🏾		person: medium-dark skin tone, blond hair	
👱🏿		person: dark skin tone, blond hair	
👨	hombre	man	hombre, man, adulto
👨🏻		man: light skin tone	
👨🏼		man: medium-light skin tone	
👨🏽		man: medium skin tone	
👨🏾		man: medium-dark skin tone	
👨🏿		man: dark skin tone	
🧔	persona con barba	person: beard	barba, beard, barbas
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
👩	mujer	woman	mujer, woman, lady
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
🧓	persona mayor	older person	mayor, older, especificado
🧓🏻		older person: light skin tone	
🧓🏼		older person: medium-light skin tone	
🧓🏽		older person: medium skin tone	
🧓🏾		older person: medium-dark skin tone	
🧓🏿		older person: dark skin tone	
👴	anciano	old man	anciano, bald, gramps
👴🏻		old man: light skin tone	
👴🏼		old man: medium-light skin tone	
👴🏽		old man: medium skin tone	
👴🏾		old man: medium-dark skin tone	
👴🏿		old man: dark skin tone	
👵	anciana	old woman	anciana, grandma, grandmother
👵🏻		old woman: light skin tone	
👵🏼		old woman: medium-light skin tone	
👵🏽		old woman: medium skin tone	
👵🏾		old woman: medium-dark skin tone	
👵🏿		old woman: dark skin tone	
🙍	persona frunciendo el ceño	person frowning	frunciendo, disgruntled, disturbed
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
🙎	persona haciendo pucheros	person pouting	pucheros, downtrodden, scowl
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
🙅	persona haciendo el gesto de "no"	person gesturing NO	gesturing, prohibit
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
🙆	persona haciendo el gesto de "de acuerdo"	person gesturing OK	exercise
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
💁	persona de mostrador de información	person tipping hand	mostrador, información, tipping
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
🙋	persona con la mano levantada	person raising hand	levantar, here, question
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
🧏	persona sorda	deaf person	sorda, deaf, escuchar
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
🙇	persona haciendo una reverencia	person bowing	reverencia, bowing, disculpa
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
🤦	persona con la mano en la frente	person facepalming	frente, facepalming, facepalm
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
🤷	persona encogida de hombros	person shrugging	encogida, hombros, shrugging
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
🧑‍🎓	estudiante	student	estudiante, student, graduado
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
👩‍🎓	estudiante mujer	woman student	graduada, licenciada, universitaria
👩🏻‍🎓		woman student: light skin tone	
👩🏼‍🎓		woman student: medium-light skin tone	
👩🏽‍🎓		woman student: medium skin tone	
👩🏾‍🎓		woman student: medium-dark skin tone	
👩🏿‍🎓		woman student: dark skin tone	
🧑‍🏫	docente	teacher	docente, teacher, educador
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
👩‍🏫	docente mujer	woman teacher	educadora, instructora, maestra
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
🧑‍🌾	profesional de la agricultura	farmer	profesional, agricultura, farmer
🧑🏻‍🌾		farmer: light skin tone	
🧑🏼‍🌾		farmer: medium-light skin tone	
🧑🏽‍🌾		farmer: medium skin tone	
🧑🏾‍🌾		farmer: medium-dark skin tone	
🧑🏿‍🌾		farmer: dark skin tone	
👨‍🌾	profesional de la agricultura hombre	man farmer	campo
👨🏻‍🌾		man farmer: light skin tone	
👨🏼‍🌾		man farmer: medium-light skin tone	
👨🏽‍🌾		man farmer: medium skin tone	
👨🏾‍🌾		man farmer: medium-dark skin tone	
👨🏿‍🌾		man farmer: dark skin tone	
👩‍🌾	profesional de la agricultura mujer	woman farmer	agricultora, granjera, labradora
👩🏻‍🌾		woman farmer: light skin tone	
👩🏼‍🌾		woman farmer: medium-light skin tone	
👩🏽‍🌾		woman farmer: medium skin tone	
👩🏾‍🌾		woman farmer: medium-dark skin tone	
👩🏿‍🌾		woman farmer: dark skin tone	
🧑‍🍳	chef	cook	chef, cook, cocinero
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
👩‍🍳	chef mujer	woman cook	cocinera
👩🏻‍🍳		woman cook: light skin tone	
👩🏼‍🍳		woman cook: medium-light skin tone	
👩🏽‍🍳		woman cook: medium skin tone	
👩🏾‍🍳		woman cook: medium-dark skin tone	
👩🏿‍🍳		woman cook: dark skin tone	
🧑‍🔧	profesional de la mecánica	mechanic	mechanic, electricista, fontanero
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
👩‍🔧	profesional de la mecánica mujer	woman mechanic	fontanera, operaria
👩🏻‍🔧		woman mechanic: light skin tone	
👩🏼‍🔧		woman mechanic: medium-light skin tone	
👩🏽‍🔧		woman mechanic: medium skin tone	
👩🏾‍🔧		woman mechanic: medium-dark skin tone	
👩🏿‍🔧		woman mechanic: dark skin tone	
🧑‍🏭	profesional industrial	factory worker	industrial, factory, worker
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
👩‍🏭	profesional industrial mujer	woman factory worker	obrera, trabajadora
👩🏻‍🏭		woman factory worker: light skin tone	
👩🏼‍🏭		woman factory worker: medium-light skin tone	
👩🏽‍🏭		woman factory worker: medium skin tone	
👩🏾‍🏭		woman factory worker: medium-dark skin tone	
👩🏿‍🏭		woman factory worker: dark skin tone	
🧑‍💼	oficinista	office worker	oficinista, office, arquitecto
🧑🏻‍💼		office worker: light skin tone	
🧑🏼‍💼		office worker: medium-light skin tone	
🧑🏽‍💼		office worker: medium skin tone	
🧑🏾‍💼		office worker: medium-dark skin tone	
🧑🏿‍💼		office worker: dark skin tone	
👨‍💼	oficinista hombre	man office worker	oficina
👨🏻‍💼		man office worker: light skin tone	
👨🏼‍💼		man office worker: medium-light skin tone	
👨🏽‍💼		man office worker: medium skin tone	
👨🏾‍💼		man office worker: medium-dark skin tone	
👨🏿‍💼		man office worker: dark skin tone	
👩‍💼	oficinista mujer	woman office worker	directora, ejecutiva
👩🏻‍💼		woman office worker: light skin tone	
👩🏼‍💼		woman office worker: medium-light skin tone	
👩🏽‍💼		woman office worker: medium skin tone	
👩🏾‍💼		woman office worker: medium-dark skin tone	
👩🏿‍💼		woman office worker: dark skin tone	
🧑‍🔬	profesional de la ciencia	scientist	ciencia, scientist, biólogo
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
👩‍🔬	profesional de la ciencia mujer	woman scientist	bióloga, científica, física
👩🏻‍🔬		woman scientist: light skin tone	
👩🏼‍🔬		woman scientist: medium-light skin tone	
👩🏽‍🔬		woman scientist: medium skin tone	
👩🏾‍🔬		woman scientist: medium-dark skin tone	
👩🏿‍🔬		woman scientist: dark skin tone	
🧑‍💻	profesional de la tecnología	technologist	tecnología, technologist, desarrollador
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
👩‍💻	profesional de la tecnología mujer	woman technologist	desarrolladora, informática, programadora
👩🏻‍💻		woman technologist: light skin tone	
👩🏼‍💻		woman technologist: medium-light skin tone	
👩🏽‍💻		woman technologist: medium skin tone	
👩🏾‍💻		woman technologist: medium-dark skin tone	
👩🏿‍💻		woman technologist: dark skin tone	
🧑‍🎤	cantante	singer	cantante, singer, artista
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
🧑‍🎨	artista	artist	artist, paleta, pintor
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
👩‍🎨	artista mujer	woman artist	pintora
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
🧑‍🚀	astronauta	astronaut	astronauta, astronaut, cohete
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
🧑‍🚒	bombero	firefighter	bombero, firefighter, camión
🧑🏻‍🚒		firefighter: light skin tone	
🧑🏼‍🚒		firefighter: medium-light skin tone	
🧑🏽‍🚒		firefighter: medium skin tone	
🧑🏾‍🚒		firefighter: medium-dark skin tone	
🧑🏿‍🚒		firefighter: dark skin tone	
👨‍🚒	bombero hombre	man firefighter	apagafuegos
👨🏻‍🚒		man firefighter: light skin tone	
👨🏼‍🚒		man firefighter: medium-light skin tone	
👨🏽‍🚒		man firefighter: medium skin tone	
👨🏾‍🚒		man firefighter: medium-dark skin tone	
👨🏿‍🚒		man firefighter: dark skin tone	
👩‍🚒	bombera	woman firefighter	bombera, mujera
👩🏻‍🚒		woman firefighter: light skin tone	
👩🏼‍🚒		woman firefighter: medium-light skin tone	
👩🏽‍🚒		woman firefighter: medium skin tone	
👩🏾‍🚒		woman firefighter: medium-dark skin tone	
👩🏿‍🚒		woman firefighter: dark skin tone	
👮	agente de policía	police officer	agente, policía, police
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
💂	guardia	guard	guardia, británica, buckingham
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
🥷	ninja	ninja	ninja, furtivo, guerrero
🥷🏻		ninja: light skin tone	
🥷🏼		ninja: medium-light skin tone	
🥷🏽		ninja: medium skin tone	
🥷🏾		ninja: medium-dark skin tone	
🥷🏿		ninja: dark skin tone	
👷	profesional de la construcción	construction worker	construcción, construction, casco
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
🫅	persona con corona	person with crown	corona, crown, majestad
🫅🏻		person with crown: light skin tone	
🫅🏼		person with crown: medium-light skin tone	
🫅🏽		person with crown: medium skin tone	
🫅🏾		person with crown: medium-dark skin tone	
🫅🏿		person with crown: dark skin tone	
🤴	príncipe	prince	príncipe, prince, king
🤴🏻		prince: light skin tone	
🤴🏼		prince: medium-light skin tone	
🤴🏽		prince: medium skin tone	
🤴🏾		prince: medium-dark skin tone	
🤴🏿		prince: dark skin tone	
👸	princesa	princess	princesa, princess, hadas
👸🏻		princess: light skin tone	
👸🏼		princess: medium-light skin tone	
👸🏽		princess: medium skin tone	
👸🏾		princess: medium-dark skin tone	
👸🏿		princess: dark skin tone	
👳	persona con turbante	person wearing turban	turbante, wearing, turban
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
👲	persona con gorro chino	person with skullcap	chino, skullcap, gua
👲🏻		person with skullcap: light skin tone	
👲🏼		person with skullcap: medium-light skin tone	
👲🏽		person with skullcap: medium skin tone	
👲🏾		person with skullcap: medium-dark skin tone	
👲🏿		person with skullcap: dark skin tone	
🧕	mujer con hiyab	woman with headscarf	hiyab, headscarf, bandana
🧕🏻		woman with headscarf: light skin tone	
🧕🏼		woman with headscarf: medium-light skin tone	
🧕🏽		woman with headscarf: medium skin tone	
🧕🏾		woman with headscarf: medium-dark skin tone	
🧕🏿		woman with headscarf: dark skin tone	
🤵	persona con esmoquin	person in tuxedo	esmoquin, tuxedo, novio
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
👰	persona con velo	person with veil	velo, veil, boda
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
🤰	mujer embarazada	pregnant woman	embarazada
🤰🏻		pregnant woman: light skin tone	
🤰🏼		pregnant woman: medium-light skin tone	
🤰🏽		pregnant woman: medium skin tone	
🤰🏾		pregnant woman: medium-dark skin tone	
🤰🏿		pregnant woman: dark skin tone	
🫃	hombre embarazado	pregnant man	embarazado, barriga, hinchado
🫃🏻		pregnant man: light skin tone	
🫃🏼		pregnant man: medium-light skin tone	
🫃🏽		pregnant man: medium skin tone	
🫃🏾		pregnant man: medium-dark skin tone	
🫃🏿		pregnant man: dark skin tone	
🫄	persona embarazada	pregnant person	embarazo, gestación, stuffed
🫄🏻		pregnant person: light skin tone	
🫄🏼		pregnant person: medium-light skin tone	
🫄🏽		pregnant person: medium skin tone	
🫄🏾		pregnant person: medium-dark skin tone	
🫄🏿		pregnant person: dark skin tone	
🤱	lactancia materna	breast-feeding	lactancia, materna, breast
🤱🏻		breast-feeding: light skin tone	
🤱🏼		breast-feeding: medium-light skin tone	
🤱🏽		breast-feeding: medium skin tone	
🤱🏾		breast-feeding: medium-dark skin tone	
🤱🏿		breast-feeding: dark skin tone	
👩‍🍼	mujer alimentando a bebé	woman feeding baby	alimentando, alimentar, feed
👩🏻‍🍼		woman feeding baby: light skin tone	
👩🏼‍🍼		woman feeding baby: medium-light skin tone	
👩🏽‍🍼		woman feeding baby: medium skin tone	
👩🏾‍🍼		woman feeding baby: medium-dark skin tone	
👩🏿‍🍼		woman feeding baby: dark skin tone	
👨‍🍼	hombre alimentando a bebé	man feeding baby	dad, father
👨🏻‍🍼		man feeding baby: light skin tone	
👨🏼‍🍼		man feeding baby: medium-light skin tone	
👨🏽‍🍼		man feeding baby: medium skin tone	
👨🏾‍🍼		man feeding baby: medium-dark skin tone	
👨🏿‍🍼		man feeding baby: dark skin tone	
🧑‍🍼	persona alimentando a bebé	person feeding baby	parent
🧑🏻‍🍼		person feeding baby: light skin tone	
🧑🏼‍🍼		person feeding baby: medium-light skin tone	
🧑🏽‍🍼		person feeding baby: medium skin tone	
🧑🏾‍🍼		person feeding baby: medium-dark skin tone	
🧑🏿‍🍼		person feeding baby: dark skin tone	
👼	bebé ángel	baby angel	church
👼🏻		baby angel: light skin tone	
👼🏼		baby angel: medium-light skin tone	
👼🏽		baby angel: medium skin tone	
👼🏾		baby angel: medium-dark skin tone	
👼🏿		baby angel: dark skin tone	
🎅	Papá Noel	Santa Claus	papá, noel, santa
🎅🏻		Santa Claus: light skin tone	
🎅🏼		Santa Claus: medium-light skin tone	
🎅🏽		Santa Claus: medium skin tone	
🎅🏾		Santa Claus: medium-dark skin tone	
🎅🏿		Santa Claus: dark skin tone	
🤶	Mamá Noel	Mrs. Claus	mamá, mrs, madre
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
🦸	personaje de superhéroe	superhero	personaje, superhéroe, superhero
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
🦹	personaje de supervillano	supervillain	supervillano, supervillain, supervillana
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
🧙	persona maga	mage	maga, mage, bruja
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
🧚	hada	fairy	hada, campanilla, oberón
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
🧛	vampiro	vampire	vampiro, vampire, drácula
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
🧜	persona sirena	merperson	sirena, merperson, tritón
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
🧝	elfo	elf	elfo, elf, mágico
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
🧞	genio	genie	genio, genie, lámpara
🧞‍♂️		man genie	
🧞‍♀️		woman genie	
🧟	zombi	zombie	zombi, zombie, apocalypse
🧟‍♂️		man zombie	
🧟‍♀️		woman zombie	
🧌	trol	troll	trol, troll, trolling
💆	persona recibiendo masaje	person getting massage	recibiendo, masaje, getting
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
💇	persona cortándose el pelo	person getting haircut	cortándose, pelo, haircut
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
🚶	persona caminando	person walking	caminando, andar, caminar
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
🧍	persona de pie	person standing	standing, levantarse, stand
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
🧎	persona de rodillas	person kneeling	rodillas, kneeling, arrodillada
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
🧑‍🦯	persona con bastón	person with white cane	bastón, cane, ciego
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
👩‍🦯	mujer con bastón	woman with white cane	ciega
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
🧑‍🦼	persona en silla de ruedas eléctrica	person in motorized wheelchair	silla, ruedas, eléctrica
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
🧑‍🦽	persona en silla de ruedas manual	person in manual wheelchair	manual
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
🏃	persona corriendo	person running	deporte, maratón, hurry
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
💃	mujer bailando	woman dancing	bailando, dancing, bailar
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
👯	personas con orejas de conejo	people with bunny ears	orejas, conejo, people
👯‍♂️		men with bunny ears	
👯‍♀️		women with bunny ears	
🧖	persona en una sauna	person in steamy room	sauna, steamy, room
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
🧗	persona escalando	person climbing	escalando, climbing, alpinista
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
🤺	persona haciendo esgrima	person fencing	esgrima, fencing, esgrimista
🏇	carrera de caballos	horse racing	caballos, horse, caballo
🏇🏻		horse racing: light skin tone	
🏇🏼		horse racing: medium-light skin tone	
🏇🏽		horse racing: medium skin tone	
🏇🏾		horse racing: medium-dark skin tone	
🏇🏿		horse racing: dark skin tone	
⛷️		skier	
🏂	practicante de snowboard	snowboarder	practicante, snowboard, snowboarder
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
🏄	persona haciendo surf	person surfing	surf, surfing, surfear
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
🚣	persona remando en un bote	person rowing boat	remando, bote, rowing
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
🏊	persona nadando	person swimming	nadando, swimming, nadar
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
🚴	persona en bicicleta	person biking	bicicleta, biking, ciclismo
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
🚵	persona en bicicleta de montaña	person mountain biking	montaña
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
🤸	persona haciendo voltereta lateral	person cartwheeling	voltereta, lateral, cartwheeling
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
🤼	personas luchando	people wrestling	luchando, wrestling, lucha
🤼‍♂️		men wrestling	
🤼‍♀️		women wrestling	
🤽	persona jugando al waterpolo	person playing water polo	jugando, waterpolo, playing
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
🤾	persona jugando al balonmano	person playing handball	balonmano, handball, balonmanista
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
🤹	persona haciendo malabares	person juggling	malabares, juggling, equilibrio
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
🧘	persona en posición de loto	person in lotus position	posición, loto, lotus
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
🛀	persona en la bañera	person taking bath	bañera, taking, bath
🛀🏻		person taking bath: light skin tone	
🛀🏼		person taking bath: medium-light skin tone	
🛀🏽		person taking bath: medium skin tone	
🛀🏾		person taking bath: medium-dark skin tone	
🛀🏿		person taking bath: dark skin tone	
🛌	persona en la cama	person in bed	cama, hotel
🛌🏻		person in bed: light skin tone	
🛌🏼		person in bed: medium-light skin tone	
🛌🏽		person in bed: medium skin tone	
🛌🏾		person in bed: medium-dark skin tone	
🛌🏿		person in bed: dark skin tone	
🧑‍🤝‍🧑	dos personas de la mano	people holding hands	pareja, couple, friends
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
👭	mujeres de la mano	women holding hands	mujeres, women, lesbianas
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
👫	mujer y hombre de la mano	woman and man holding hands	novios
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
👬	hombres de la mano	men holding hands	hombres, men, gays
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
💏	beso	kiss	babe, mwah
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
💑	pareja enamorada	couple with heart	enamoradas, relationship
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
👤	silueta de busto	bust in silhouette	silueta, busto, bust
👥	dos siluetas de bustos	busts in silhouette	siluetas, bustos, busts
🫂	personas abrazándose	people hugging	abrazándose, adiós, despedida
👪	familia	family	familia, family
🧑‍🧑‍🧒	familia: adulto, adulto, niño	family: adult, adult, child	
🧑‍🧑‍🧒‍🧒	familia: adulto, adulto, niño, niño	family: adult, adult, child, child	
🧑‍🧒	familia: adulto, niño	family: adult, child	
🧑‍🧒‍🧒	familia: adulto, niño, niño	family: adult, child, child	
👣	huellas de pies	footprints	huellas, pies, footprints
🐵	cara de mono	monkey face	banana
🐒	mono	monkey	macaco, simio
🦍	gorila	gorilla	gorila, gorilla, primate
🦧	orangután	orangutan	orangután, ape
🐶	cara de perro	dog face	perro, mascota, pet
🐕	perro	dog	cachorro, perrete, perrito
🦮	perro guía	guide dog	guía, guide, lazarillo
🐕‍🦺	perro de servicio	service dog	servicio, service, apoyo
🐩	caniche	poodle	caniche, poodle, fluffy
🐺	lobo	wolf	lobo, wolf
🦊	zorro	fox	zorro, fox
🦝	mapache	raccoon	mapache, raccoon, astuto
🐱	cara de gato	cat face	kitten, kitty
🐈	gato	cat	gatete, minino, cats
🐈‍⬛	gato negro	black cat	mala, feline, meow
🦁	león	lion	león, lion, leo
🐯	cara de tigre	tiger face	tigre, tiger, predator
🐅	tigre	tiger	felino, zoo
🐆	leopardo	leopard	leopardo, leopard
🐴	cara de caballo	horse face	dressage, equine, farm
🫎	alce	moose	alce, moose, asta
🫏	burro	donkey	burro, donkey, asno
🐎	caballo	horse	ecuestre, equestrian
🦄	unicornio	unicorn	unicornio, unicorn
🦓	cebra	zebra	cebra, zebra, raya
🦌	ciervo	deer	deer, bambi, cervatillo
🦬	bisonte	bison	bisonte, bison, búfalo
🐮	cara de vaca	cow face	vaca, cow, milk
🐂	buey	ox	buey, cabestro, tauro
🐃	búfalo de agua	water buffalo	agua
🐄	vaca	cow	bovino, res
🐷	cara de cerdo	pig face	cerdo, pig, gorrino
🐖	cerdo	pig	cochino, puerco, sow
🐗	jabalí	boar	jabalí, boar, salvaje
🐽	nariz de cerdo	pig nose	morro, snout
🐏	carnero	ram	carnero, ram, aries
🐑	oveja	ewe	oveja, ewe, borrego
🐐	cabra	goat	cabra, goat, capricornio
🐪	dromedario	camel	dromedario, camel, camello
🐫	camello	two-hump camel	bactriano, jorobas, bactrian
🦙	llama	llama	llama, alpaca, guanaco
🦒	jirafa	giraffe	jirafa, giraffe, manchas
🐘	elefante	elephant	elefante, elephant, paquidermo
🦣	mamut	mammoth	mamut, mammoth, colmillo
🦏	rinoceronte	rhinoceros	rinoceronte, rhinoceros
🦛	hipopótamo	hippopotamus	hipopótamo, hippopotamus, hippo
🐭	cara de ratón	mouse face	ratón, mouse
🐁	ratón	mouse	roedor
🐀	rata	rat	rata, rat
🐹	hámster	hamster	hámster
🐰	cara de conejo	rabbit face	rabbit
🐇	conejo	rabbit	conejito, gazapo
🐿️		chipmunk	
🦫	castor	beaver	castor, beaver, dam
🦔	erizo	hedgehog	erizo, hedgehog, espinas
🦇	murciélago	bat	murciélago, bat
🐻	oso	bear	oso, bear, grizzly
🐻‍❄️		polar bear	
🐨	koala	koala	koala, marsupial, australia
🐼	panda	panda	panda, bamboo
🦥	perezoso	sloth	perezoso, sloth, gandul
🦦	nutria	otter	nutria, otter, bromista
🦨	mofeta	skunk	mofeta, skunk, apestar
🦘	canguro	kangaroo	canguro, kangaroo, saltar
🦡	tejón	badger	tejón, badger, ratel
🐾	huellas de pezuñas	paw prints	pezuñas, paw, prints
🦃	pavo	turkey	pavo, turkey, ave
🐔	gallina	chicken	gallina, chicken, gallinácea
🐓	gallo	rooster	gallo, rooster
🐣	pollito rompiendo el cascarón	hatching chick	pollito, rompiendo, cascarón
🐤	pollito	baby chick	polluelo
🐥	pollito de frente	front-facing baby chick	front
🐦	pájaro	bird	pájaro, pajarillo
🐧	pingüino	penguin	pingüino, penguin, antarctica
🕊️		dove	
🦅	águila	eagle	águila, eagle
🦆	pato	duck	pato, duck
🦢	cisne	swan	cisne, swan, patito
🦉	búho	owl	búho, owl, lechuza
🦤	dodo	dodo	dodo, dronte, mauricio
🪶	pluma	feather	pluma, feather, ligero
🦩	flamenco	flamingo	flamingo, extravangante, ostentoso
🦚	pavo real	peacock	peacock, plumas, colorful
🦜	loro	parrot	loro, parrot, hablar
🪽	ala	wing	ala, wing, angelical
🐦‍⬛	pájaro negro	black bird	cuervo, grajo, mirlo
🪿	oca	goose	oca, goose, ganso
🐦‍🔥	fénix	phoenix	fénix, phoenix, fuego
🐸	rana	frog	rana, frog
🐊	cocodrilo	crocodile	cocodrilo, crocodile, caimán
🐢	tortuga	turtle	tortuga, turtle, galápago
🦎	lagarto	lizard	lagarto, lizard, lagartija
🐍	serpiente	snake	serpiente, snake, culebra
🐲	cara de dragón	dragon face	dragón
🐉	dragón	dragon	knights
🦕	saurópodo	sauropod	saurópodo, sauropod, braquiosaurio
🦖	t-rex	T-Rex	rex, tiranosaurio, tyrannosaurus
🐳	ballena soltando un chorro	spouting whale	ballena, soltando, chorro
🐋	ballena	whale	cachalote, cetáceo
🐬	delfín	dolphin	delfín, dolphin, flipper
🦭	foca	seal	foca, seal, marino
🐟	pez	fish	pez, fish, pececillo
🐠	pez tropical	tropical fish	
🐡	pez globo	blowfish	globo, blowfish
🦈	tiburón	shark	tiburón, shark
🐙	pulpo	octopus	pulpo, octopus, cefalópodo
🐚	caracola	spiral shell	caracola, shell, concha
🪸	coral	coral	coral, arrecife, océano
🪼	medusa	jellyfish	medusa, jellyfish, invertebrado
🐌	caracol	snail	caracol, snail, molusco
🦋	mariposa	butterfly	mariposa, butterfly, insecto
🐛	bicho	bug	bicho, bug, gusano
🐜	hormiga	ant	hormiga, ant, antenas
🐝	abeja	honeybee	abeja, honeybee, bee
🪲	escarabajo	beetle	escarabajo, beetle
🐞	mariquita	lady beetle	mariquita, cochinilla, ladybird
🦗	grillo	cricket	grillo, cricket, saltamontes
🪳	cucaracha	cockroach	cucaracha, cockroach, alimaña
🕷️		spider	
🕸️		spider web	
🦂	escorpión	scorpion	escorpión, scorpion, escorpio
🦟	mosquito	mosquito	mosquito, malaria, virus
🪰	mosca	fly	mosca, basura, podrido
🪱	gusano	worm	worm, lombriz, oruga
🦠	microbio	microbe	microbio, microbe, ameba
💐	ramo de flores	bouquet	ramo, flores, bouquet
🌸	flor de cerezo	cherry blossom	flor, cerezo, cherry
💮	flor blanca	white flower	blanca
🪷	loto	lotus	budismo, hinduismo, pureza
🏵️		rosette	
🌹	rosa	rose	rose
🥀	flor marchita	wilted flower	marchita, wilted, marchitada
🌺	flor de hibisco	hibiscus	hibisco, hibiscus
🌻	girasol	sunflower	girasol, sunflower, outdoors
🌼	flor	blossom	buttercup, dandelion
🌷	tulipán	tulip	tulipán, tulip, growth
🪻	campanilla	hyacinth	hyacinth, jacinto, lavanda
🌱	planta joven	seedling	planta, seedling, plantón
🪴	planta de maceta	potted plant	maceta, potted, crecer
🌲	árbol de hoja perenne	evergreen tree	árbol, hoja, perenne
🌳	árbol de hoja caduca	deciduous tree	caduca, deciduous, caducifolio
🌴	palmera	palm tree	palmera
🌵	cactus	cactus	cactus, drought
🌾	espiga de arroz	sheaf of rice	espiga, arroz, sheaf
🌿	hierba	herb	hierba, herb, leaf
☘️		shamrock	
🍀	trébol de cuatro hojas	four leaf clover	trébol, cuatro, hojas
🍁	hoja de arce	maple leaf	arce, maple, falling
🍂	hojas caídas	fallen leaf	caídas, fallen, caída
🍃	hojas revoloteando al viento	leaf fluttering in wind	revoloteando, viento, fluttering
🪹	nido vacío	empty nest	nido, vacío, empty
🪺	nido con huevos	nest with eggs	huevos, eggs
🍄	champiñón	mushroom	champiñón, mushroom, hongo
🍇	uvas	grapes	uvas, grapes, agracejo
🍈	melón	melon	melón, cantaloupe
🍉	sandía	watermelon	sandía, watermelon
🍊	mandarina	tangerine	mandarina, tangerine, citrus
🍋	limón	lemon	limón, lemon, cítrico
🍋‍🟩	lima	lime	lima, lime, acidity
🍌	plátano	banana	plátano, potassium
🍍	piña	pineapple	piña, pineapple, ananás
🥭	mango	mango	mango
🍎	manzana roja	red apple	manzana, apple, poma
🍏	manzana verde	green apple	
🍐	pera	pear	pera, pear, perilla
🍑	melocotón	peach	melocotón, peach, durazno
🍒	cerezas	cherries	cerezas, cherries, cereza
🍓	fresa	strawberry	fresa, strawberry, fresón
🫐	arándanos	blueberries	arándanos, blueberries, arándano
🥝	kiwi	kiwi fruit	kiwi
🍅	tomate	tomato	tomate, tomato, ensalada
🫒	aceituna	olive	aceituna, olive, aperitivo
🥥	coco	coconut	coco, coconut
🥑	aguacate	avocado	aguacate, avocado
🍆	berenjena	eggplant	berenjena, eggplant, fruto
🥔	patata	potato	patata, potato
🥕	zanahoria	carrot	zanahoria, carrot
🌽	espiga de maíz	ear of corn	maíz, corn, mazorca
🌶️		hot pepper	
🫑	pimiento	bell pepper	pimiento, bell, pepper
🥒	pepino	cucumber	pepino, cucumber, pepinillo
🥬	verdura de hoja verde	leafy green	leafy, bok, choy
🥦	brócoli	broccoli	brócoli, broccoli, repollo
🧄	ajo	garlic	ajo, garlic, condimento
🧅	cebolla	onion	cebolla, onion
🥜	cacahuetes	peanuts	cacahuetes, peanuts, cacahuete
🫘	alubias	beans	alubias, beans, habichuela
🌰	castaña	chestnut	castaña, chestnut, castaño
🫚	raíz de jengibre	ginger root	raíz, jengibre, ginger
🫛	vaina	pea pod	vaina, pea, pod
🍄‍🟫	champiñón marrón	brown mushroom	naturaleza, vegetal, fungi
🍞	pan de molde	bread	pan, molde, bread
🥐	cruasán	croissant	cruasán, croissant, bollo
🥖	baguete	baguette bread	baguete, baguette, barra
🫓	pan sin levadura	flatbread	levadura, flatbread, arepa
🥨	bretzel	pretzel	bretzel, pretzel, galleta
🥯	bagel	bagel	bagel, panadería, bakery
🥞	tortitas	pancakes	tortitas, pancakes, dulce
🧇	gofre	waffle	gofre, waffle, indecisive
🧀	cuña de queso	cheese wedge	cuña, queso, cheese
🍖	carne con hueso	meat on bone	carne, meat, restaurante
🍗	muslo de pollo	poultry leg	muslo, poultry, drumstick
🥩	corte de carne	cut of meat	chuleta, filete, lambchop
🥓	beicon	bacon	beicon, panceta
🍔	hamburguesa	hamburger	hamburguesa, hamburger, burger
🍟	patatas fritas	french fries	patatas, fritas, fries
🍕	pizza	pizza	porción, pepperoni, slice
🌭	perrito caliente	hot dog	caliente, salchicha, frankfurter
🥪	sándwich	sandwich	sándwich, bocata, emparedado
🌮	taco	taco	taco, mexicano, mexican
🌯	burrito	burrito	burrito, tex, mex
🫔	tamal	tamale	tamal, tamale, mejicano
🥙	pan relleno	stuffed flatbread	relleno, durum, falafel
🧆	falafel	falafel	albóndiga, garbanzo, chickpea
🥚	huevo	egg	
🍳	cocinar	cooking	cocinar, cooking, freír
🥘	paella	shallow pan of food	paella, shallow, casserole
🍲	olla de comida	pot of food	olla, puchero, soup
🫕	fondue	fondue	fondue, chocolate, suizo
🥣	cuenco con cuchara	bowl with spoon	cuenco, cuchara, bowl
🥗	ensalada	green salad	bol
🍿	palomitas	popcorn	palomitas, popcorn, movie
🧈	mantequilla	butter	mantequilla, butter, lácteo
🧂	sal	salt	sal, salt, salero
🥫	comida enlatada	canned food	enlatada, canned, conserva
🍱	caja de bento	bento box	caja, bento, box
🍘	galleta de arroz	rice cracker	cracker
🍙	bola de arroz	rice ball	bola, onigiri, japanese
🍚	arroz cocido	cooked rice	cocido, cooked
🍛	arroz con curry	curry rice	curry
🍜	tazón de fideos	steaming bowl	tazón, fideos, steaming
🍝	espagueti	spaghetti	espagueti, spaghetti, pasta
🍠	patata asada	roasted sweet potato	asada, roasted
🍢	brocheta	oden	brocheta, oden, marisco
🍣	sushi	sushi	sushi
🍤	gamba frita	fried shrimp	gamba, frita, fried
🍥	pastel de pescado japonés	fish cake with swirl	pastel, cake, swirl
🥮	pastel de luna	moon cake	luna, moon, festival
🍡	dango	dango	dango, dessert
🥟	dumpling	dumpling	dumpling, jiaozi, masa
🥠	galleta de la fortuna	fortune cookie	fortuna, fortune, cookie
🥡	caja para llevar	takeout box	llevar, takeout, recipiente
🦀	cangrejo	crab	cangrejo, crab, cáncer
🦞	bogavante	lobster	bogavante, lobster, langosta
🦐	gamba	shrimp	camarón, langostino, shellfish
🦑	calamar	squid	calamar, squid, mollusk
🦪	ostra	oyster	ostra, buceo, perla
🍦	cucurucho de helado	soft ice cream	cucurucho, soft, ice
🍧	granizado hawaiano	shaved ice	granizado, hawaiano, shaved
🍨	helado	ice cream	sorbete
🍩	dónut	doughnut	dónut, doughnut, berlina
🍪	galleta	cookie	chip
🎂	tarta de cumpleaños	birthday cake	tarta, cumpleaños
🍰	trozo de tarta	shortcake	shortcake, pedazo
🧁	magdalena	cupcake	magdalena, cupcake, repostería
🥧	pastel	pie	filling, pumpkin
🍫	tableta de chocolate	chocolate bar	tableta, bar, candy
🍬	caramelo	candy	caramelo, chuche, chuchería
🍭	piruleta	lollipop	piruleta, lollipop
🍮	flan	custard	flan, custard, pudding
🍯	tarro de miel	honey pot	tarro, barrel, honeypot
🍼	biberón	baby bottle	biberón, bottle, bibe
🥛	vaso de leche	glass of milk	vaso, glass, bebida
☕	bebida caliente	hot beverage	beverage, café, caffeine
🫖	tetera	teapot	tetera, teapot, infusión
🍵	tazón de té	teacup without handle	teacup, taza, cup
🍶	sake	sake	sake
🍾	botella descorchada	bottle with popping cork	descorchada, popping, cork
🍷	copa de vino	wine glass	copa, vino, wine
🍸	copa de cóctel	cocktail glass	cóctel, martini
🍹	bebida tropical	tropical drink	mai, tai, tropics
🍺	jarra de cerveza	beer mug	jarra, mug, ale
🍻	jarras de cerveza brindando	clinking beer mugs	jarras, brindando, clinking
🥂	copas brindando	clinking glasses	copas, brindar, brindis
🥃	vaso de whisky	tumbler glass	whisky, tumbler, chupito
🫗	líquido derramándose	pouring liquid	derramándose, pouring, derramar
🥤	vaso con pajita	cup with straw	pajita, straw, refresco
🧋	té de burbujas	bubble tea	burbujas, boba
🧃	tetrabrik	beverage box	tetrabrik, brick, cartón
🧉	mate	mate	mate
🧊	cubito de hielo	ice	cubito, iceberg, cube
🥢	palillos	chopsticks	palillos, cubiertos, hashi
🍽️		fork and knife with plate	
🍴	tenedor y cuchillo	fork and knife	tenedor, cuchillo, fork
🥄	cuchara	spoon	cucharilla, tableware
🔪	cuchillo de cocina	kitchen knife	cocina, kitchen, arma
🫙	tarro	jar	almacenar, frasco, container
🏺	ánfora	amphora	ánfora, amphora, acuario
🌍	globo terráqueo mostrando Europa y África	globe showing Europe-Africa	terráqueo, mostrando, europa
🌎	globo terráqueo mostrando América	globe showing Americas	américa, americas
🌏	globo terráqueo mostrando Asia y Australia	globe showing Asia-Australia	asia
🌐	globo terráqueo con meridianos	globe with meridians	meridianos, meridians, internet
🗺️		world map	
🗾	mapa de Japón	map of Japan	mapa, japón, map
🧭	brújula	compass	brújula, compass, compás
🏔️		snow-capped mountain	
⛰️		mountain	
🌋	volcán	volcano	volcán, volcano, erupción
🗻	monte Fuji	mount fuji	monte, fuji, mount
🏕️		camping	
🏖️		beach with umbrella	
🏜️		desert	
🏝️		desert island	
🏞️		national park	
🏟️		stadium	
🏛️		classical building	
🏗️		building construction	
🧱	ladrillo	brick	ladrillo, arcilla, cemento
🪨	piedra	rock	piedra, pedrusco, peñasco
🪵	madera	wood	madera, wood, hoguera
🛖	cabaña	hut	cabaña, hut, casa
🏘️		houses	
🏚️		derelict house	
🏠	casa	house	vivienda, building, country
🏡	casa con jardín	house with garden	jardín
🏢	edificio de oficinas	office building	edificio, oficinas, city
🏣	oficina de correos japonesa	Japanese post office	correos, post
🏤	oficina de correos europea	post office	europea, european
🏥	hospital	hospital	hospital, medicina, médico
🏦	banco	bank	banco, bank, banca
🏨	hotel	hotel	alojamiento, turismo
🏩	hotel del amor	love hotel	
🏪	tienda 24 horas	convenience store	tienda, horas, convenience
🏫	colegio	school	colegio, school, escuela
🏬	grandes almacenes	department store	almacenes, department, comercio
🏭	fábrica	factory	industria
🏯	castillo japonés	Japanese castle	castillo, castle
🏰	castillo europeo	castle	europeo
💒	iglesia celebrando boda	wedding	iglesia, chapel, hitched
🗼	Torre de Tokio	Tokyo tower	torre, tokio, tokyo
🗽	Estatua de la Libertad	Statue of Liberty	estatua, libertad, statue
⛪	iglesia	church	cristianismo, cruz, religión
🕌	mezquita	mosque	mezquita, mosque, islam
🛕	templo hindú	hindu temple	templo, hindú, temple
🕍	sinagoga	synagogue	sinagoga, synagogue, judaísmo
⛩️		shinto shrine	
🕋	Kaaba	kaaba	kaaba, hach, musulmán
⛲	fuente	fountain	fuente, fountain
⛺	tienda de campaña	tent	campaña, tent, camping
🌁	bruma	foggy	bruma, foggy, niebla
🌃	noche estrellada	night with stars	noche, estrellada
🏙️		cityscape	
🌄	amanecer sobre montañas	sunrise over mountains	amanecer, montañas, sunrise
🌅	amanecer	sunrise	
🌆	ciudad al atardecer	cityscape at dusk	ciudad, atardecer, cityscape
🌇	puesta del sol	sunset	puesta
🌉	puente de noche	bridge at night	puente, bridge
♨️		hot springs	
🎠	caballo de tiovivo	carousel horse	tiovivo, carousel, entretenimiento
🛝	tobogán	playground slide	tobogán, playground, jugar
🎡	noria de feria	ferris wheel	noria, feria, ferris
🎢	montaña rusa	roller coaster	rusa, roller, coaster
💈	poste de barbero	barber pole	poste, barbero, pole
🎪	carpa de circo	circus tent	carpa, circo, circus
🚂	locomotora de vapor	locomotive	locomotora, locomotive, tren
🚃	vagón	railway car	vagón, car, ferrocarril
🚄	tren de alta velocidad	high-speed train	alta, velocidad, rápido
🚅	tren bala	bullet train	bala, bullet
🚆	tren	train	arrived, choo
🚇	metro	metro	metro, subterráneo, suburbano
🚈	tren ligero	light rail	rail, monorail
🚉	estación de tren	station	estación, station
🚊	tranvía	tram	trolebús
🚝	monorraíl	monorail	monorraíl, monocarril, vehicle
🚞	ferrocarril de montaña	mountain railway	trip
🚋	vagón de tranvía	tram car	bus, trolley
🚌	autobús	bus	autobús
🚍	autobús próximo	oncoming bus	próximo, cars
🚎	trolebús	trolleybus	
🚐	minibús	minibus	minibús, drive, van
🚑	ambulancia	ambulance	ambulancia, ambulance, emergency
🚒	coche de bomberos	fire engine	coche, bomberos, truck
🚓	coche de policía	police car	patrulla, cops, patrol
🚔	coche de policía próximo	oncoming police car	
🚕	taxi	taxi	taxi, cab, cabbie
🚖	taxi próximo	oncoming taxi	drove, hail
🚗	coche	automobile	automobile, automóvil, driving
🚘	coche próximo	oncoming automobile	
🚙	vehículo deportivo utilitario	sport utility vehicle	deportivo, utilitario, utility
🛻	camioneta	pickup truck	camioneta, pickup, ranchera
🚚	camión de reparto	delivery truck	reparto, mercancías
🚛	camión articulado	articulated lorry	articulado, articulated, lorry
🚜	tractor	tractor	tractor
🏎️		racing car	
🏍️		motorcycle	
🛵	scooter	motor scooter	scooter, motor, escúter
🦽	silla de ruedas manual	manual wheelchair	
🦼	silla de ruedas eléctrica	motorized wheelchair	
🛺	mototaxi	auto rickshaw	mototaxi, auto, rickshaw
🚲	bicicleta	bicycle	bici, class, cycling
🛴	patinete	kick scooter	patinete
🛹	monopatín	skateboard	monopatín, skateboard, tabla
🛼	patines	roller skate	patines, patín, blades
🚏	parada de autobús	bus stop	parada, busstop
🛣️		motorway	
🛤️		railway track	
🛢️		oil drum	
⛽	surtidor de gasolina	fuel pump	surtidor, gasolina, fuel
🛞	rueda	wheel	círculo, girar, neumático
🚨	luces de policía	police car light	luces, alarm, alert
🚥	semáforo horizontal	horizontal traffic light	semáforo, horizontal, traffic
🚦	semáforo	vertical traffic light	vertical
🛑	señal de stop	stop sign	octágono, octagonal
🚧	obras	construction	obras, barrier
⚓	ancla	anchor	ancla, anchor, barco
🛟	salvavidas	ring buoy	salvavidas, buoy, flotador
⛵	velero	sailboat	velero, sailboat, vela
🛶	canoa	canoe	canoa, piragua
🚤	lancha motora	speedboat	lancha, motora, speedboat
🛳️		passenger ship	
⛴️		ferry	
🛥️		motor boat	
🚢	barco	ship	passenger
✈️		airplane	
🛩️		small airplane	
🛫	avión despegando	airplane departure	avión, despegando, airplane
🛬	avión aterrizando	airplane arrival	aterrizando, arrival, llegada
🪂	paracaídas	parachute	paracaídas, parachute, delta
💺	asiento de transporte	seat	asiento, seat, plaza
🚁	helicóptero	helicopter	helicóptero, helicopter, aspas
🚟	ferrocarril de suspensión	suspension railway	suspensión
🚠	teleférico de montaña	mountain cableway	teleférico, cableway, cable
🚡	teleférico	aerial tramway	aerial, tramway, aéreo
🛰️		satellite	
🚀	cohete	rocket	launch, rockets
🛸	platillo volante	flying saucer	platillo, volante, saucer
🛎️		bellhop bell	
🧳	equipaje	luggage	equipaje, luggage, maleta
⌛	reloj de arena sin tiempo	hourglass done	reloj, arena, tiempo
⏳	reloj de arena con tiempo	hourglass not done	cayendo, flowing, waiting
⌚	reloj	watch	clock
⏰	reloj despertador	alarm clock	despertador, alarma, hrs
⏱️		stopwatch	
⏲️		timer clock	
🕰️		mantelpiece clock	
🕛	12 en punto	twelve o’clock	punto, twelve, doce
🕧	doce y media	twelve-thirty	media, thirty
🕐	1 en punto	one o’clock	
🕜	una y media	one-thirty	
🕑	2 en punto	two o’clock	
🕝	dos y media	two-thirty	
🕒	3 en punto	three o’clock	tres
🕞	tres y media	three-thirty	
🕓	4 en punto	four o’clock	
🕟	cuatro y media	four-thirty	
🕔	5 en punto	five o’clock	
🕠	cinco y media	five-thirty	
🕕	6 en punto	six o’clock	six, seis
🕡	seis y media	six-thirty	
🕖	7 en punto	seven o’clock	seven, siete
🕢	siete y media	seven-thirty	
🕗	8 en punto	eight o’clock	eight, ocho
🕣	ocho y media	eight-thirty	
🕘	9 en punto	nine o’clock	nine, nueve
🕤	nueve y media	nine-thirty	
🕙	10 en punto	ten o’clock	ten, diez
🕥	diez y media	ten-thirty	
🕚	11 en punto	eleven o’clock	eleven, once
🕦	once y media	eleven-thirty	
🌑	luna nueva	new moon	oscuridad, dark
🌒	luna creciente	waxing crescent moon	waxing, cuarto, dreams
🌓	luna en cuarto creciente	first quarter moon	first, quarter
🌔	luna gibosa creciente	waxing gibbous moon	gibosa, gibbous
🌕	luna llena	full moon	llena, plenilunio
🌖	luna gibosa menguante	waning gibbous moon	menguante, waning
🌗	luna en cuarto menguante	last quarter moon	last
🌘	luna menguante	waning crescent moon	
🌙	luna	crescent moon	ramadan
🌚	luna nueva con cara	new moon face	
🌛	luna de cuarto creciente con cara	first quarter moon face	
🌜	luna de cuarto menguante con cara	last quarter moon face	
🌡️		thermometer	
☀️		sun	
🌝	luna llena con cara	full moon face	
🌞	sol con cara	sun with face	shine, sunshine, weather
🪐	planeta con anillos	ringed planet	anillos, ringed, planet
⭐	estrella	star	estelar, astronomy, medium
🌟	estrella brillante	glowing star	glowing, resplandeciente, glittery
🌠	estrella fugaz	shooting star	fugaz, lluvia
🌌	Vía Láctea	milky way	vía, láctea, milky
☁️		cloud	
⛅	sol detrás de una nube	sun behind cloud	detrás, nube, behind
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
🌀	ciclón	cyclone	ciclón, cyclone, tifón
🌈	arcoíris	rainbow	arcoíris, rainbow, colores
🌂	paraguas cerrado	closed umbrella	paraguas, umbrella, accesorios
☂️		umbrella	
☔	paraguas con gotas de lluvia	umbrella with rain drops	
⛱️		umbrella on ground	
⚡	alto voltaje	high voltage	voltaje, voltage, electricidad
❄️		snowflake	
☃️		snowman	
⛄	muñeco de nieve	snowman without snow	muñeco, snowman
☄️		comet	
🔥	fuego	fire	flame, lit, litaf
💧	gota	droplet	gota
🌊	ola de mar	water wave	ola, mar
🎃	calabaza de Halloween	jack-o-lantern	calabaza, jack, lantern
🎄	árbol de Navidad	Christmas tree	abeto
🎆	fuegos artificiales	fireworks	fuegos, artificiales, fireworks
🎇	bengala	sparkler	bengala, sparkler
🧨	petardo	firecracker	petardo, firecracker, dinamita
✨	chispas	sparkles	chispas, sparkles
🎈	globo	balloon	
🎉	cañón de confeti	party popper	cañón, confeti, popper
🎊	bola de confeti	confetti ball	confetti
🎋	árbol de tanabata	tanabata tree	tanabata, festividad, banner
🎍	decoración de pino	pine decoration	decoración, pino, año
🎎	muñecas japonesas	Japanese dolls	muñecas, japonesas, dolls
🎏	banderín de carpas	carp streamer	banderín, carpas, carp
🎐	campanilla de viento	wind chime	chime, furin
🎑	ceremonia de contemplación de la luna	moon viewing ceremony	ceremonia, contemplación, viewing
🧧	sobre rojo	red envelope	envelope, buena, hóngb
🎀	lazo	ribbon	
🎁	regalo	wrapped gift	envoltorio, presente, envuelto
🎗️		reminder ribbon	
🎟️		admission tickets	
🎫	tique	ticket	tique, ticket, acceso
🎖️		military medal	
🏆	trofeo	trophy	trofeo, trophy, premio
🏅	medalla deportiva	sports medal	medalla, deportiva, sports
🥇	medalla de oro	1st place medal	oro, place, primero
🥈	medalla de plata	2nd place medal	segundo, second
🥉	medalla de bronce	3rd place medal	bronce, tercero, bronze
⚽	balón de fútbol	soccer ball	balón, fútbol, soccer
⚾	béisbol	baseball	béisbol, baseball, pelota
🥎	pelota de softball	softball	softball, glove, underarm
🏀	balón de baloncesto	basketball	baloncesto, basketball, canasta
🏐	pelota de voleibol	volleyball	voleibol, volleyball, juego
🏈	balón de fútbol americano	american football	americano, american, super
🏉	balón de rugby	rugby football	rugby
🎾	pelota de tenis	tennis	tenis, tennis, racquet
🥏	disco volador	flying disc	disco, volador, disc
🎳	bolos	bowling	bolos, bowling, strike
🏏	críquet	cricket game	críquet
🏑	hockey sobre hierba	field hockey	hockey, field, palo
🏒	hockey sobre hielo	ice hockey	
🥍	lacrosse	lacrosse	lacrosse, raqueta, goal
🏓	tenis de mesa	ping pong	mesa, ping, pong
🏸	bádminton	badminton	bádminton, birdie, shuttlecock
🥊	guante de boxeo	boxing glove	guante, boxeo, boxing
🥋	uniforme de artes marciales	martial arts uniform	uniforme, artes, marciales
🥅	portería	goal net	portería, net
⛳	banderín en hoyo	flag in hole	hoyo, flag, hole
⛸️		ice skate	
🎣	caña de pescar	fishing pole	caña, pescar, esparcimiento
🤿	máscara de buceo	diving mask	bucear, buzo, esnórquel
🎽	camiseta sin mangas	running shirt	camiseta, mangas, shirt
🎿	esquís	skis	esquís, skis, esquí
🛷	trineo	sled	trineo, sled, luge
🥌	piedra de curling	curling stone	curling
🎯	diana	bullseye	diana, bullseye, dart
🪀	yoyó	yo-yo	yoyó, dieta, efecto
🪁	cometa	kite	cometa, kite, planear
🔫	pistola de agua	water pistol	pistola, pistol, verano
🎱	bola negra de billar	pool 8 ball	negra, billar, pool
🔮	bola de cristal	crystal ball	cristal, crystal, future
🪄	varita mágica	magic wand	varita, mágica, wand
🎮	mando de videoconsola	video game	mando, videoconsola, video
🕹️		joystick	
🎰	máquina tragaperras	slot machine	máquina, tragaperras, slot
🎲	dado	game die	dado, die, dice
🧩	pieza de puzle	puzzle piece	pieza, puzle, puzzle
🧸	osito de peluche	teddy bear	osito, peluche, teddy
🪅	piñata	piñata	piñata, caballito, mayo
🪩	bola de espejos	mirror ball	espejos, mirror, brillar
🪆	muñeca rusa	nesting dolls	muñeca, babushka, mamushka
♠️		spade suit	
♥️		heart suit	
♦️		diamond suit	
♣️		club suit	
♟️		chess pawn	
🃏	comodín	joker	comodín, joker, card
🀄	dragón rojo de mahjong	mahjong red dragon	mahjong
🎴	cartas de flores	flower playing cards	cartas, cards, hanafuda
🎭	máscaras de teatro	performing arts	máscaras, teatro, performing
🖼️		framed picture	
🎨	paleta de pintor	artist palette	pintura, artsy, arty
🧵	hilo	thread	hilo, thread, aguja
🪡	aguja de coser	sewing needle	bordado, hilar, tejer
🧶	ovillo	yarn	ovillo, yarn, croché
🪢	nudo	knot	nudo, knot, anudar
👓	gafas	glasses	ropa, eyeglasses, eyewear
🕶️		sunglasses	
🥽	gafas de protección	goggles	protección, goggles, ocular
🥼	bata de laboratorio	lab coat	bata, laboratorio, lab
🦺	chaleco de seguridad	safety vest	chaleco, vest, emergencia
👔	corbata	necktie	corbata, necktie, accesorio
👕	camiseta	t-shirt	casual, dressed, shopping
👖	vaqueros	jeans	vaqueros, jeans, pantalones
🧣	bufanda	scarf	bufanda, scarf, abrigo
🧤	guantes	gloves	guantes, gloves
🧥	abrigo	coat	chaquetón, brr
🧦	calcetines	socks	calcetines, socks, stocking
👗	vestido	dress	vestido, dress
👘	kimono	kimono	kimono, comfortable
🥻	sari	sari	sari, prenda
🩱	traje de baño de una pieza	one-piece swimsuit	traje, swimsuit, bañador
🩲	ropa interior	briefs	interior, briefs, bragas
🩳	pantalones cortos	shorts	cortos, shorts, bermudas
👙	bikini	bikini	bikini, playa
👚	ropa de mujer	woman’s clothes	blusa, camisa, femenina
🪭	abanico abierto	folding hand fan	abanico, abierto, folding
👛	monedero	purse	monedero, purse, cartera
👜	bolso	handbag	bolso
👝	bolso de mano	clutch bag	clutch, pouch
🛍️		shopping bags	
🎒	mochila escolar	backpack	mochila, escolar, backpack
🩴	chancla	thong sandal	chancla, thong, sandal
👞	zapato de hombre	man’s shoe	zapato, calzado, shoes
👟	zapatilla deportiva	running shoe	zapatilla, athletic, sneaker
🥾	bota de senderismo	hiking boot	bota, senderismo, hiking
🥿	bailarina	flat shoe	bailarina, flat, ballet
👠	zapato de tacón	high-heeled shoe	tacón, heeled, fashion
👡	sandalia de mujer	woman’s sandal	
🩰	zapatillas de ballet	ballet shoes	zapatillas, balé, danza
👢	bota de mujer	woman’s boot	
🪮	peineta	hair pick	afro, peine, comb
👑	corona	crown	reina, rey, medieval
👒	sombrero de mujer	woman’s hat	hats
🎩	sombrero de copa	top hat	top, chistera, tophat
🎓	birrete	graduation cap	birrete, graduation, graduación
🧢	gorra con visera	billed cap	gorra, visera, billed
🪖	casco militar	military helmet	militar, military, guerra
⛑️		rescue worker’s helmet	
📿	rosario	prayer beads	rosario, beads, cuentas
💄	pintalabios	lipstick	pintalabios
💍	anillo	ring	anillo, diamante, diamond
💎	piedra preciosa	gem stone	preciosa, gem, gema
🔇	altavoz silenciado	muted speaker	altavoz, silenciado, muted
🔈	altavoz a volumen bajo	speaker low volume	volumen, bajo, low
🔉	altavoz a volumen medio	speaker medium volume	medio
🔊	altavoz a volumen alto	speaker high volume	loud, music
📢	altavoz de mano	loudspeaker	loudspeaker, comunicación, address
📣	megáfono	megaphone	megáfono, megaphone, cheering
📯	corneta de posta	postal horn	corneta, posta, postal
🔔	campana	bell	
🔕	campana con signo de cancelación	bell with slash	slash, ruido
🎼	pentagrama	musical score	pentagrama, musical, música
🎵	nota musical	musical note	nota
🎶	notas musicales	musical notes	notas, musicales, notes
🎙️		studio microphone	
🎚️		level slider	
🎛️		control knobs	
🎤	micrófono	microphone	micrófono, microphone, karaoke
🎧	auricular	headphone	auricular, headphone, cascos
📻	radio	radio	radio, tbt
🎷	saxofón	saxophone	saxofón, saxophone, instrumento
🪗	acordeón	accordion	acordeón, accordion, concertina
🎸	guitarra	guitar	guitarra, guitar, strat
🎹	teclado musical	musical keyboard	teclado, keyboard, piano
🎺	trompeta	trumpet	trompeta, trumpet
🎻	violín	violin	violín
🪕	banjo	banjo	banjo, banyo, cuerda
🥁	tambor	drum	tambor, drum, baquetas
🪘	tamboril	long drum	tamboril, long, conga
🪇	maracas	maracas	maracas, brasil, movimiento
🪈	flauta	flute	flauta, flute, flautín
📱	teléfono móvil	mobile phone	móvil, mobile, celular
📲	móvil con una flecha	mobile phone with arrow	llamada, recibir, receive
☎️		telephone	
📞	auricular de teléfono	telephone receiver	receiver, voip
📟	busca	pager	busca, pager, localizador
📠	máquina de fax	fax machine	fax
🔋	pila	battery	pila, battery, batería
🪫	batería baja	low battery	baja, carga, electrónico
🔌	enchufe eléctrico	electric plug	enchufe, plug, corriente
💻	ordenador portátil	laptop	ordenador, portátil, laptop
🖥️		desktop computer	
🖨️		printer	
⌨️		keyboard	
🖱️		computer mouse	
🖲️		trackball	
💽	minidisc	computer disk	minidisc, disk, minidisk
💾	disquete	floppy disk	disquete, floppy
💿	disco óptico	optical disk	óptico, blu, ray
📀	disco DVD	dvd	
🧮	ábaco	abacus	ábaco, abacus, cálculo
🎥	cámara de cine	movie camera	cine, película, bollywood
🎞️		film frames	
📽️		film projector	
🎬	claqueta	clapper board	claqueta, clapper, action
📺	televisión	television	televisión
📷	cámara de fotos	camera	fotos, photo
📸	cámara con flash	camera with flash	flash
📹	videocámara	video camera	videocámara, camcorder
📼	cinta de vídeo	videocassette	cinta, videocassette, tape
🔍	lupa orientada hacia la izquierda	magnifying glass tilted left	lupa, orientada, magnifying
🔎	lupa orientada hacia la derecha	magnifying glass tilted right	contact
🕯️		candle	
💡	bombilla	light bulb	bombilla, bulb
🔦	linterna	flashlight	flashlight, torch
🏮	lámpara japonesa	red paper lantern	paper, izakaya
🪔	lámpara de aceite	diya lamp	aceite, diya, oil
📔	cuaderno con tapa decorativa	notebook with decorative cover	cuaderno, tapa, decorativa
📕	libro cerrado	closed book	libro
📖	libro abierto	open book	knowledge, library, novels
📗	libro verde	green book	
📘	libro azul	blue book	
📙	libro naranja	orange book	
📚	libros	books	libros, books, study
📓	cuaderno	notebook	libreta
📒	libro de contabilidad	ledger	contabilidad, ledger
📃	página doblada	page with curl	página, doblada, page
📜	pergamino	scroll	pergamino, scroll, papel
📄	página hacia arriba	page facing up	anverso
📰	periódico	newspaper	periódico, newspaper, diario
🗞️		rolled-up newspaper	
📑	marcadores	bookmark tabs	marcadores, bookmark, tabs
🔖	marcapáginas	bookmark	marcapáginas, marcador
🏷️		label	
💰	bolsa de dinero	money bag	bolsa, dólares, billion
🪙	moneda	coin	moneda, metal, tesoro
💴	billete de yen	yen banknote	billete, yen, banknote
💵	billete de dólar	dollar banknote	dólar
💶	billete de euro	euro banknote	
💷	billete de libra	pound banknote	libra, pounds
💸	billete con alas	money with wings	alas, pay
💳	tarjeta de crédito	credit card	tarjeta, crédito, credit
🧾	recibo	receipt	recibo, receipt, prueba
💹	mercado al alza	chart increasing with yen	mercado, alza, chart
✉️		envelope	
📧	correo electrónico	e-mail	email
📨	sobre entrante	incoming envelope	entrante, incoming, delivering
📩	sobre con flecha	envelope with arrow	outgoing, send
📤	bandeja de salida	outbox tray	bandeja, outbox, tray
📥	bandeja de entrada	inbox tray	entrada, inbox, recibido
📦	paquete	package	paquete, package, parcel
📫	buzón cerrado con la bandera levantada	closed mailbox with raised flag	buzón, bandera, mailbox
📪	buzón cerrado con la bandera bajada	closed mailbox with lowered flag	bajada, lowered
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
📝	cuaderno de notas	memo	memo, pencil
💼	maletín	briefcase	maletín, briefcase, documentos
📁	carpeta de archivos	file folder	carpeta, archivos, file
📂	carpeta de archivos abierta	open file folder	
🗂️		card index dividers	
📅	calendario	calendar	calendario, calendar, fecha
📆	calendario recortable	tear-off calendar	recortable, off
🗒️		spiral notepad	
🗓️		spiral calendar	
📇	organizador de fichas	card index	organizador, fichas, ficha
📈	gráfica de evolución ascendente	chart increasing	gráfica, evolución, ascendente
📉	gráfica de evolución descendente	chart decreasing	descendente, decreasing, downward
📊	gráfico de barras	bar chart	barras
📋	portapapeles	clipboard	portapapeles, clipboard, papeles
📌	chincheta	pushpin	chincheta, pushpin, tachuela
📍	chincheta redonda	round pushpin	redonda, round, location
📎	clip	paperclip	clip, paperclip
🖇️		linked paperclips	
📏	regla	straight ruler	regla, ruler, angle
📐	escuadra	triangular ruler	escuadra, triangular, triángulo
✂️		scissors	
🗃️		card file box	
🗄️		file cabinet	
🗑️		wastebasket	
🔒	candado cerrado	locked	candado, locked, cerrar
🔓	candado abierto	unlocked	unlocked, abrir, cracked
🔏	candado con pluma estilográfica	locked with pen	estilográfica, pen, privacidad
🔐	candado cerrado y llave	locked with key	llave, seguro, secure
🔑	llave	key	contraseña, keys, major
🗝️		old key	
🔨	martillo	hammer	martillo, hammer, herramienta
🪓	hacha	axe	hacha, axe, cortar
⛏️		pick	
⚒️		hammer and pick	
🛠️		hammer and wrench	
🗡️		dagger	
⚔️		crossed swords	
💣	bomba	bomb	dangerous
🪃	bumerán	boomerang	bumerán, boomerang, rebotar
🏹	arco y flecha	bow and arrow	arco, arquero, sagitario
🛡️		shield	
🪚	sierra de carpintería	carpentry saw	sierra, carpintería, carpentry
🔧	llave inglesa	wrench	inglesa, wrench, spanner
🪛	destornillador	screwdriver	destornillador, screwdriver, atornillador
🔩	tornillo y tuerca	nut and bolt	tuerca, bolt
⚙️		gear	
🗜️		clamp	
⚖️		balance scale	
🦯	bastón	white cane	ceguera
🔗	eslabón	link	eslabón, link, links
⛓️‍💥		broken chain	
⛓️		chains	
🪝	gancho	hook	hook, agarrar, anzuelo
🧰	caja de herramientas	toolbox	herramientas, toolbox, armario
🧲	imán	magnet	imán, magnet, atracción
🪜	escalera	ladder	escalera, ladder, escalar
⚗️		alembic	
🧪	tubo de ensayo	test tube	ensayo, test, tube
🧫	placa de petri	petri dish	placa, petri, dish
🧬	adn	dna	adn, dna, gen
🔬	microscopio	microscope	microscopio, microscope
🔭	telescopio	telescope	telescopio, telescope, astronomía
📡	antena de satélite	satellite antenna	antena, satélite, satellite
💉	jeringuilla	syringe	jeringuilla, syringe, jeringa
🩸	gota de sangre	drop of blood	sangre, donación, donar
💊	píldora	pill	píldora, pill, comprimido
🩹	tirita	adhesive bandage	tirita, adhesive, apósito
🩼	muleta	crutch	muleta, crutch, ayuda
🩺	estetoscopio	stethoscope	estetoscopio, stethoscope, fonendoscopio
🩻	radiografía	x-ray	radiografía, doctora, huesos
🚪	puerta	door	puerta, door, closet
🛗	ascensor	elevator	ascensor, elevator, elevador
🪞	espejo	mirror	espejo, espéculo, reflector
🪟	ventana	window	ventana, window, abertura
🛏️		bed	
🛋️		couch and lamp	
🪑	silla	chair	sentarse, sit
🚽	inodoro	toilet	inodoro, toilet, váter
🪠	desatascador	plunger	desatascador, plunger, retrete
🚿	ducha	shower	ducha, shower
🛁	bañera	bathtub	
🪤	trampa de ratones	mouse trap	trampa, ratones, trap
🪒	cuchilla de afeitar	razor	cuchilla, afeitar, razor
🧴	bote de crema	lotion bottle	crema, lotion, champú
🧷	imperdible	safety pin	imperdible, pañal, punk
🧹	escoba	broom	escoba, broom, barrer
🧺	cesta	basket	cesta, basket, cosecha
🧻	rollo de papel	roll of paper	rollo, absorbente, higiénico
🪣	cubo	bucket	cubo, bucket, balde
🧼	jabón	soap	jabón, soap, bañarse
🫧	burbujas	bubbles	bubbles, eructar, limpiar
🪥	cepillo de dientes	toothbrush	cepillo, dientes, toothbrush
🧽	esponja	sponge	esponja, sponge, poroso
🧯	extintor	fire extinguisher	extintor, extinguisher, apagar
🛒	carrito de la compra	shopping cart	carrito, compra, cart
🚬	cigarrillo	cigarette	cigarrillo, cigarette, cigarro
⚰️		coffin	
🪦	lápida	headstone	lápida, headstone, cementario
⚱️		funeral urn	
🧿	ojo turco	nazar amulet	turco, nazar, amulet
🪬	hamsa	hamsa	hamsa, fátima, jamsa
🗿	estatua moái	moai	moái, pascua, moyai
🪧	letrero	placard	letrero, placard, anuncio
🪪	carné de identidad	identification card	identidad, identification, conducir
🏧	señal de cajero automático	ATM sign	cajero, automático, atm
🚮	señal de usar papelera	litter in bin sign	usar, papelera, litter
🚰	agua potable	potable water	potable
♿	símbolo de silla de ruedas	wheelchair symbol	access, handicap
🚹	aseo para hombres	men’s room	aseo, caballeros, lavatory
🚺	señal de aseo para mujeres	women’s room	señoras
🚻	señal de aseos	restroom	aseos, servicios
🚼	señal de bebé	baby symbol	cambiar, changing
🚾	aseos	water closet	lavabo
🛂	control de pasaportes	passport control	control, pasaportes, passport
🛃	aduana	customs	aduana, customs
🛄	recogida de equipajes	baggage claim	recogida, equipajes, baggage
🛅	consigna	left luggage	consigna, depósito, locker
⚠️		warning	
🚸	niños cruzando	children crossing	niños, cruzando, crossing
⛔	dirección prohibida	no entry	dirección, prohibida, entry
🚫	prohibido	prohibited	entrar, pasar, prohibición
🚳	bicicletas prohibidas	no bicycles	bicicletas, prohibidas, bicycles
🚭	prohibido fumar	no smoking	
🚯	prohibido tirar basura	no littering	littering
🚱	agua no potable	non-potable water	non, dry
🚷	prohibido el paso de peatones	no pedestrians	paso, peatones, pedestrians
📵	prohibido el uso de móviles	no mobile phones	uso, móviles, phones
🔞	prohibido para menos de 18 años	no one under eighteen	años, eighteen, apto
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
🔃	flechas verticales en sentido horario	clockwise vertical arrows	flechas, verticales, sentido
🔄	flechas en sentido antihorario	counterclockwise arrows button	antihorario, counterclockwise, button
🔙	flecha BACK	BACK arrow	atrás
🔚	flecha END	END arrow	end, final
🔛	flecha ON!	ON! arrow	doble, punta, palabra
🔜	flecha SOON	SOON arrow	soon, brb
🔝	flecha TOP	TOP arrow	
🛐	lugar de culto	place of worship	lugar, culto, worship
⚛️		atom symbol	
🕉️		om	
✡️		star of David	
☸️		wheel of dharma	
☯️		yin yang	
✝️		latin cross	
☦️		orthodox cross	
☪️		star and crescent	
☮️		peace symbol	
🕎	menorá	menorah	menorá, menorah, candelabro
🔯	estrella de seis puntas	dotted six-pointed star	puntas, pointed
🪯	khanda	khanda	khanda, sij, sijismo
♈	Aries	Aries	horóscopo, horoscope
♉	Tauro	Taurus	toro
♊	Géminis	Gemini	géminis, gemini, gemelos
♋	Cáncer	Cancer	
♌	Leo	Leo	
♍	Virgo	Virgo	
♎	Libra	Libra	balanza, escala, justicia
♏	Escorpio	Scorpio	
♐	Sagitario	Sagittarius	
♑	Capricornio	Capricorn	
♒	Acuario	Aquarius	
♓	Piscis	Pisces	
⛎	Ofiuco	Ophiuchus	ofiuco, portador
🔀	reproducción aleatoria	shuffle tracks button	reproducción, aleatoria, shuffle
🔁	repetir	repeat button	repetir, repeat, repetición
🔂	repetir una vez	repeat single button	vez, single
▶️		play button	
⏩	avance rápido	fast-forward button	avance, forward, avanzar
⏭️		next track button	
⏯️		play or pause button	
◀️		reverse button	
⏪	retroceso rápido	fast reverse button	retroceso, reverse, rebobinado
⏮️		last track button	
🔼	triángulo hacia arriba	upwards button	upwards, botón
⏫	triángulo doble hacia arriba	fast up button	
🔽	triángulo hacia abajo	downwards button	downwards
⏬	triángulo doble hacia abajo	fast down button	
⏸️		pause button	
⏹️		stop button	
⏺️		record button	
⏏️		eject button	
🎦	cine	cinema	
🔅	brillo bajo	dim button	brillo, dim, tenue
🔆	brillo alto	bright button	
📶	barras de cobertura	antenna bars	cobertura, bars
🛜	wifi	wireless	wifi, wireless, conexión
📳	modo vibración	vibration mode	modo, vibración, vibration
📴	teléfono móvil apagado	mobile phone off	apagado
♀️		female sign	
♂️		male sign	
⚧️		transgender symbol	
✖️		multiply	
➕	más	plus	más, plus, suma
➖	menos	minus	minus, resta
➗	división	divide	división, divide
🟰	signo igual grueso	heavy equals sign	igual, grueso, equals
♾️		infinity	
‼️		double exclamation mark	
⁉️		exclamation question mark	
❓	interrogación roja	red question mark	interrogación, pregunta, puntuación
❔	interrogación blanca	white question mark	outlined
❕	exclamación blanca	white exclamation mark	exclamación, exclamation, bang
❗	exclamación roja	red exclamation mark	
〰️		wavy dash	
💱	cambio de divisas	currency exchange	cambio, divisas, exchange
💲	símbolo de dólar	heavy dollar sign	
⚕️		medical symbol	
♻️		recycling symbol	
⚜️		fleur-de-lis	
🔱	emblema de tridente	trident emblem	emblema, tridente, emblem
📛	etiqueta identificativa	name badge	etiqueta, identificativa, name
🔰	símbolo japonés para principiante	Japanese symbol for beginner	principiante, for, beginner
⭕	círculo rojo hueco	hollow red circle	hueco, hollow, aro
✅	botón de marca de verificación	check mark button	verificación, selección, checkmark
☑️		check box with check	
✔️		check mark	
❌	marca de cruz	cross mark	cancelar, tachado, tachar
❎	botón con marca de cruz	cross mark button	casilla, square
➰	bucle	curly loop	bucle, curly, loop
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
🔠	letras latinas mayúsculas	input latin uppercase	letras, latinas, mayúsculas
🔡	letras latinas minúsculas	input latin lowercase	minúsculas, lowercase
🔢	números	input numbers	números, numbers, dígitos
🔣	símbolos	input symbols	
🔤	alfabeto latino	input latin letters	alfabeto, latino, abc
🅰️		A button (blood type)	
🆎	grupo sanguíneo AB	AB button (blood type)	grupo, sanguíneo, type
🅱️		B button (blood type)	
🆑	borrar	CL button	borrar
🆒	botón COOL	COOL button	mola
🆓	botón FREE	FREE button	free, gratis
ℹ️		information	
🆔	símbolo de identificación	ID button	identity
Ⓜ️		circled M	
🆕	botón NEW	NEW button	
🆖	botón NG	NG button	
🅾️		O button (blood type)	
🆗	botón OK	OK button	
🅿️		P button	
🆘	símbolo de socorro	SOS button	socorro, sos
🆙	botón UP!	UP! button	novedad
🆚	botón VS	VS button	contra, versus
🈁	ideograma japonés para "aquí"	Japanese “here” button	ideograma, aquí, katakana
🈂️		Japanese “service charge” button	
🈷️		Japanese “monthly amount” button	
🈶	ideograma japonés para "de pago"	Japanese “not free of charge” button	pago, kanji, ideograph
🈯	ideograma japonés para "reservado"	Japanese “reserved” button	reservado, reserved
🉐	ideograma japonés para "ganga"	Japanese “bargain” button	ganga, bargain
🈹	ideograma japonés para "descuento"	Japanese “discount” button	descuento, discount
🈚	ideograma japonés para "gratis"	Japanese “free of charge” button	
🈲	ideograma japonés para "prohibido"	Japanese “prohibited” button	
🉑	ideograma japonés para "aceptable"	Japanese “acceptable” button	aceptable, acceptable
🈸	ideograma japonés para "aplicación"	Japanese “application” button	aplicación, application
🈴	ideograma japonés para "aprobado"	Japanese “passing grade” button	aprobado, passing, grade
🈳	ideograma japonés para "vacante"	Japanese “vacancy” button	vacante, vacancy
㊗️		Japanese “congratulations” button	
㊙️		Japanese “secret” button	
🈺	ideograma japonés para "abierto"	Japanese “open for business” button	
🈵	ideograma japonés para "completo"	Japanese “no vacancy” button	completo
🔴	círculo rojo	red circle	geometría, geometric
🟠	círculo naranja	orange circle	
🟡	círculo amarillo	yellow circle	
🟢	círculo verde	green circle	
🔵	círculo azul	blue circle	
🟣	círculo morado	purple circle	púrpura
🟤	círculo marrón	brown circle	
⚫	círculo negro	black circle	
⚪	círculo blanco	white circle	
🟥	cuadrado rojo	red square	cuadrado, penalty
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
◾	cuadrado negro mediano-pequeño	black medium-small square	mediano
◽	cuadrado blanco mediano-pequeño	white medium-small square	
▪️		black small square	
▫️		white small square	
🔶	rombo naranja grande	large orange diamond	rombo
🔷	rombo azul grande	large blue diamond	
🔸	rombo naranja pequeño	small orange diamond	
🔹	rombo azul pequeño	small blue diamond	
🔺	triángulo rojo hacia arriba	red triangle pointed up	
🔻	triángulo rojo hacia abajo	red triangle pointed down	
💠	rombo con pétalo	diamond with a dot	pétalo, dot
🔘	botón de opción	radio button	opción
🔳	botón cuadrado con borde blanco	white square button	borde
🔲	botón cuadrado con borde negro	black square button	
🏁	bandera de cuadros	chequered flag	cuadros, chequered, checkered
🚩	bandera triangular	triangular flag	localización, informativa
🎌	banderas cruzadas	crossed flags	banderas, cruzadas
🏴	bandera negra	black flag	ondear
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

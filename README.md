# RE2016_6
Šifrovanje- projekat 6

Napisati program koji kodira tekst koji se kuca na tastaturi Vigenèr-ovom šifrom. Prilikom
kucanja poruke na standardnom izlazu se prikazuje šifrovana poruka. Prilikom pokretanja
teksta se pita prvo za ključnu re£. Ključna reč treba da bude pisana velikim slovima, kao i sam
tekst. Nakon toga se po kucanju teksta kodira reč po reč i ispisuje na standardni izlaz.
Primer kodiranja je:

Otvoreni tekst: ATTACKATDAWN

Ključ: LEMONLEMONLE

Šifra: LXFOPVEFRNHR.

Naime, otvoreni tekst se sabira po modulu 26 sa ključem. Ukoliko je ključ duži od teksta,
sabira se onoliko znakova koliko je dugačka reč teksta. Ako je reč duža od ključa, ključ se
ponavlja koliko je puta potrebno kao u primeru iznad. Formula za računanje vrednosti kodirane
reči je:
Si ≡ Oi + Ki (mod 26),
gde je Oi, i-to slovo re£i, Ki ključa, a Si slovo kodirane reči.

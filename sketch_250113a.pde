//  változók
float cubeY; // A kocka függőleges pozíciója
int groundHeight = 175; // A "föld" magassága
float[] data; // Magasságadatok a CSV-ből
int dataIndex = 0; // Az aktuális adat indexe
PFont font;
boolean parachuteDeployed = false; // Ejtőernyő ki van-e nyitva
boolean parachuteVisible = true; // Ejtőernyő láthatósága
float maxAltitude; // Maximum magasság
float parachuteY; // Ejtőernyő függőleges pozíciója
boolean descending = false; // Leereszkedik-e

void setup() {
  size(600, 400);
  font = createFont("Arial", 14);
  textFont(font);

  // CSV-ből adat betöltése
  Table table = loadTable("data.csv", "header");
  data = new float[table.getRowCount()];
  for (int i = 0; i < table.getRowCount(); i++) {
    data[i] = table.getFloat(i, "magassag");
  }

  maxAltitude = max(data); // Maximum magasság kiszámítása

  cubeY = height / 2; // A kocka induló pozíciója (középen)
  parachuteY = cubeY - 75; // Az ejtőernyő induló pozíciója a kocka felett
}

void draw() {
  background(135, 206, 250); // Kék égbolt

  // Kamera követi a kockát
  float cameraOffset = map(data[dataIndex], 0, max(data), 0, height);
  translate(0, cameraOffset);

  // Föld kirajzolása fix pozícióban
  fill(34, 139, 34);
  rect(0, height - groundHeight, width, groundHeight);

  // Kólásdoboz rajzolása
  drawColaCan(width / 2, cubeY - 25);

  // Ejtőernyő megjelenítése, ha a kólásdoboz eléri a legnagyobb magasságot vagy visszaesik
  if (data[dataIndex] == maxAltitude || descending) {
    parachuteDeployed = true;
  }

  if (parachuteDeployed && parachuteVisible) {
    drawParachute(width / 2, parachuteY);
    parachuteY += 1; // Az ejtőernyő süllyed késleltetve
  }

  // Debug adatok megjelenítése 
  resetMatrix();
  fill(0);
  text("Magasság: " + data[dataIndex] + " ", 10, 20);
  text("Index: " + dataIndex, 10, 40);
  text("Legnagyobb érték: " + maxAltitude + " ", 10, 60);
  text("Reset: r", 10, 80);
  text("Ejtőernyő toggle: e", 10, 100);

  // Kólásdoboz pozíciójának mozgatása
  if (dataIndex < data.length - 1 && !descending) {
    dataIndex++;
  } else if (dataIndex == data.length - 1) {
    descending = true;
  } else if (dataIndex > 0) {
    dataIndex--;
  }

  // A kólásdoboz mozgása felfelé és lefelé
  cubeY = height / 2 - map(data[dataIndex], 0, max(data), 0, height);
  parachuteY = cubeY - 75; // Az ejtőernyő követi a kockát, de később lemarad
}

// Ejtőernyő kirajzolása
void drawParachute(float x, float y) {
  fill(255, 0, 0);
  noStroke();
  arc(x, y, 80, 80, PI, TWO_PI); // Ejtőernyő kupola
  stroke(0);
  line(x - 40, y, x - 15, y + 50); // Bal oldali zsinór
  line(x + 40, y, x + 15, y + 50); // Jobb oldali zsinór
}

// Kólásdoboz kirajzolása
void drawColaCan(float x, float y) {
  fill(255, 0, 0);
  rect(x - 12.5, y, 25, 50, 10); // Kólásdoboz teste lekerekített sarkokkal
}

// Reset funkció billentyű lenyomására
void keyPressed() {
  if (key == 'r' || key == 'R') {
    resetVisualization();
  }

  // Toggle az ejtőernyő láthatóságára
  if (key == 'e' || key == 'E') {
    parachuteVisible = !parachuteVisible;
  }
}

// Vizualizáció újraindítása
void resetVisualization() {
  dataIndex = 0;
  descending = false;
  parachuteDeployed = false;
  parachuteVisible = true; // Az ejtőernyőt újra láthatóvá tesszük a resetnél
  cubeY = height / 2;
  parachuteY = cubeY - 75;
}

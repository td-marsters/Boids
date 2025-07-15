final int N_BOIDS = 300;
Boid[] boids = new Boid[N_BOIDS];
void setup() {
  size(2000, 800); 
  background(50);
  for(int i = 0; i < N_BOIDS; i++) {
    boids[i] = new Boid(); 
  }
}

void draw() {
  background(50);
  for (Boid b : boids) {
    b.show(); 
    b.update();
    b.flock(boids);
    b.moveTowards(new PVector(mouseX, mouseY));
  }
}

void mousePressed() {
  for(int i = 0; i < N_BOIDS; i++) {
    boids[i] = new Boid(); 
  }
}

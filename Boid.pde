class Boid {

  PVector position, acceleration, velocity;
  float maxForce, maxSpeed, r;
  
  Boid() {
    position = new PVector(random(width), random(height));
    velocity = PVector.random2D();
    acceleration = new PVector(0, 0);
    maxForce = 0.2;
    maxSpeed = 1.5;
    r = 2;
  }

  void borders() { 
    if(position.x < -r) { position.x = width+r; }
    else if (position.x > width+r) { position.x = -r; }
    if(position.y < -r) { position.y = height+r; }
    else if (position.y > height+r) { position.y = -r; }
  }

  PVector moveTowards(PVector target) {
    PVector newVelocity = PVector.sub(target, position); 
    
    newVelocity.normalize();
    newVelocity.mult(maxSpeed);
    
    PVector steer = PVector.sub(newVelocity, velocity);
    steer.limit(maxForce);
    return steer;
  }

  PVector align(Boid[] boids) {
    // Need the average of all surrounds boid velocities and add it to acceleration
    PVector steering = new PVector(0, 0); // Averages var
    int total = 0;
    int perceivableRadius = 100;

    for (Boid other : boids) {
      float distance = PVector.dist(position, other.position);

      if (other != this && distance < perceivableRadius) {
        steering.add(other.velocity);
        total++;
      }
    }

    if (total > 0) {
      steering.div(total);
    }
    steering.sub(velocity);
    return steering;
  }

  PVector seperate(Boid[] boids) {
    // Need the average distance between flockmates and slow
    PVector steering = new PVector(0, 0); // Averages var
    int total = 0;
    int keptDistance = 30;

    for (Boid other : boids) {

      float distance = PVector.dist(position, other.position);

      if (distance > 0  && distance < keptDistance) {
        PVector diff  = PVector.sub(position, other.position);

        diff.div(distance);
        steering.add(diff);
        total++;
      }
    }
    if (total > 0) {
      steering.div((float) total); 
    }
    
    /*if (steering.mag() > 0) {
      steering.normalize();
      steering.mult(maxSpeed);
      steering.sub(velocity);
      steering.limit(maxForce);
    } */
    steering.normalize();
    steering.mult(maxSpeed);
    steering.sub(velocity);
    steering.limit(maxForce);
    return steering;
  }

  PVector cohesion(Boid[] boids) {
    // Find the average position of neighbours and move towards it
    float perceivableRadius = 50.0f;
    PVector sum = new PVector(0, 0);
    int total = 0;
    
    for (Boid other : boids) {
      float distance = PVector.dist(position, other.position);
      if((distance > 0) && distance < perceivableRadius) {
        sum.add(other.position);
        total++;
      }
    }
    
    if (total > 0) {
      sum.div(total); 
      return moveTowards(sum);
    }
    
    return new PVector(0, 0);
  }

  void flock(Boid[] boids) {
    /* Will eventually have all boid algorithm methods */

    //acceleration.add(cohesion(boids));
    acceleration.add(align(boids));
    acceleration.add(seperate(boids));
    acceleration.normalize();
    acceleration.mult(maxForce);
  }

  void velocityLine() {
    PVector nextPos = position.copy();
    PVector tempVelocity = velocity.copy();
    tempVelocity.mult(10);
    nextPos.add(tempVelocity);
    stroke(0);
    strokeWeight(1);
    line(position.x, position.y, nextPos.x, nextPos.y);
    strokeWeight(8);
    stroke(255);
  }
  
  void render() {
    float theta = velocity.heading()+radians(90);
    fill(55, 100);
    stroke(200);
    pushMatrix();
    
    translate(position.x, position.y);
    rotate(theta);
    beginShape(TRIANGLES);
    vertex(0, -r*2);
    vertex(-r, r*2);
    vertex(r, r*2);
    endShape();
    popMatrix();
  }

  void show() {
    render();
    //velocityLine();
  }

  void update() {
    velocity.add(acceleration);
    velocity.normalize();
    velocity.mult(maxSpeed);
    position.add(velocity);
    borders();
  }
}

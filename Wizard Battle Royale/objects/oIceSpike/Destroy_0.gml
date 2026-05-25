
var particles = particle_get_type(ParticleSystem4, 0);
part_type_life(particles, 20, 30);
part_type_direction(particles, 0, 360, 0, 0);
part_particles_create(oGameplayHandler.particle_system, x, y, particles, 20);
var particles = particle_get_type(psOrbitOrb, 0);
part_type_life(particles, 8, 15);
part_type_direction(particles, 0, 360, 0, 0);
part_particles_create(oGameplayHandler.particle_system, x, y, particles, 10);
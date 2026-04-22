var particles = particle_get_type(psFireball, 0);
part_type_size(particles, 0.25, 0.25, 0, 0.05);
part_type_life(particles, 20, 30);
part_particles_create(oGameplayHandler.particle_system, x, y, particles, 20);
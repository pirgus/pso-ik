classdef Particle

    properties
        position;
        velocity;
        own_best;
        inertia_factor;
        cog_factor;
        social_factor;
        fitness;
    end

    methods
        function particle = Particle(position, velocity, inertia, ...
                cognitive, social)
            particle.position = position;
            particle.velocity = velocity;
            particle.inertia_factor = inertia;
            particle.cog_factor = cognitive;
            particle.social_factor = social;
            particle = update_fitness(particle);

            particle.own_best = {[0, 0, 0, 0], inf};
        end

        function particle = update_fitness(particle)
            particle.fitness = particle_fitness(particle);
        end

        function particle = update_velocity(particle, global_best)
            % random cognitive and social factors
            r1 = rand;
            r2 = rand;
            particle.velocity = particle.inertia_factor * particle.velocity + ...
                particle.cog_factor * r1 * (particle.own_best{1} - particle.position) + ...
                particle.social_factor * r2 * (global_best{1} - particle.position);
        end

        function particle = update_position(particle)
            particle.position = particle.position + particle.velocity;
        end

    end

end
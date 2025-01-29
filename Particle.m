classdef Particle

    properties
        position;
        velocity;
        own_best;
        inertia_factor;
        cog_factor;
        social_factor;
        fitness;
        num_joints;
    end

    methods
        function particle = Particle(position, velocity, inertia, ...
                cognitive, social, num_joints)
            particle.position = position;
            particle.velocity = velocity;
            particle.inertia_factor = inertia;
            particle.cog_factor = cognitive;
            particle.social_factor = social;
            particle.num_joints = num_joints;
            particle = updateFitness(particle);

            particle.own_best = {zeros(1, particle.num_joints), inf};
        end

        function particle = updateFitness(particle)
            particle.fitness = particle_fitness(particle);
        end

        function particle = updateVelocity(particle, global_best)
            % random cognitive and social factors
            r1 = rand;
            r2 = rand;
            particle.velocity = particle.inertia_factor * particle.velocity + ...
                particle.cog_factor * r1 * (particle.own_best{1} - particle.position) + ...
                particle.social_factor * r2 * (global_best{1} - particle.position);
        end

        function particle = updatePosition(particle)
            particle.position = particle.position + particle.velocity;
        end

    end

end
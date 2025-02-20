classdef Particle

    properties
        position;
        velocity;
        own_best;
        inertia_factor;
        cog_factor;
        social_factor;
        fitness;
        q_min;
        q_max;
        robot;
    end

    methods
        function particle = Particle(position, velocity, inertia, ...
                cognitive, social, q_min, q_max, robot)
            particle.position = position;
            particle.velocity = velocity;
            particle.inertia_factor = inertia;
            particle.cog_factor = cognitive;
            particle.social_factor = social;
            particle.q_min = q_min;
            particle.q_max = q_max;
            particle = updateFitness(particle);
            particle.robot = robot;

            particle.own_best = {zeros(1, length(particle.q_min)), inf};
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
            if any(particle.position > particle.q_max) || any(particle.position < particle.q_min)
                particle.position = max(particle.q_min, min(particle.position, particle.q_max));
%                   particle.position = generate_r_config(particle.robot);
            end
        end

    end

end
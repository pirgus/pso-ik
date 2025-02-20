classdef PSO_R

    properties
        num_particles;
        num_iterations;
        inertia_factor;
        cog_factor;
        social_factor;
        particles;
        global_best;
        robot;
        q_min;
        q_max;
        tol;
    end
   
    methods
        function pso = PSO_R(num_particles, num_iterations, ...
                inertia_factor, cog_factor, social_factor, robot, tol, q_min, q_max)
            pso.num_particles = num_particles;
            pso.num_iterations = num_iterations;
            pso.inertia_factor = inertia_factor;
            pso.cog_factor = cog_factor;
            pso.social_factor = social_factor;
            pso.robot = robot;
            pso.tol = tol;
            pso.q_min = q_min;
            pso.q_max = q_max;

            pso.global_best = {zeros(1, length(length(pso.robot.Bodies))), inf};
        end

        function pso = initParticles(pso)
            for i = 1:pso.num_particles
                random_config = generate_r_config(pso.robot);
                random_velocity = -1 + 1.5*rand(1, length(pso.robot.Bodies));
                new_particle = Particle(random_config, random_velocity, ...
                    pso.inertia_factor, pso.cog_factor, ...
                    pso.social_factor, pso.q_min, pso.q_max, pso.robot);
                pso.particles = [pso.particles, new_particle];
            end
        end

        function pso = optmProcess(pso)
            i = 0;
            while i < pso.num_iterations
                for j = 1:pso.num_particles
                    pso.particles(j) = pso.particles(j).updateVelocity(pso.global_best);
                    pso.particles(j) = pso.particles(j).updatePosition;
                    pso.particles(j) = pso.particles(j).updateFitness;
                    
                    if pso.particles(j).fitness < pso.particles(j).own_best{2}
                        pso.particles(j).own_best = {pso.particles(j).position, ...
                                                    pso.particles(j).fitness};
                    end

                    if pso.particles(j).fitness < pso.global_best{2}
                        pso.global_best = {pso.particles(j).position, ...
                                            pso.particles(j).fitness};
                    end
                end

                if pso.global_best{2} < pso.tol
                    break;
                else
                    i = i + 1;
                end
            end
        end

    end
    
end
classdef PSO_R

    properties
        num_particles;
        num_iterations;
        inertia_factor;
        cog_factor;
        social_factor;
        particles;
        global_best;
        joints_limits;
        verbose;
    end
   
    methods
        function pso = PSO_R(num_particles, num_iterations, ...
                inertia_factor, cog_factor, social_factor, joints_limits, verbose)
            pso.num_particles = num_particles;
            pso.num_iterations = num_iterations;
            pso.inertia_factor = inertia_factor;
            pso.cog_factor = cog_factor;
            pso.social_factor = social_factor;
            pso.joints_limits = joints_limits;
            pso.verbose = verbose;

            pso.global_best = {zeros(1, length(pso.joints_limits)), inf};
        end

        function pso = initParticles(pso)
            for i = 1:pso.num_particles
                random_config = generate_r_config(pso.joints_limits);
                random_velocity = -1 + 1.5*rand(1, length(pso.joints_limits));
                new_particle = Particle(random_config, random_velocity, ...
                    pso.inertia_factor, pso.cog_factor, ...
                    pso.social_factor, length(pso.joints_limits));
                pso.particles = [pso.particles, new_particle];
            end
        end

        function pso = optmProcess(pso)
            for i = 1:pso.num_iterations
                if(pso.verbose)
                    disp(['------------ iteration ', num2str(i), ' ------------']);
                end
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
                
                if(pso.verbose)
                    disp(['global best for this iteration (position, fitness) => ', ...
                    mat2str(pso.global_best{1}, 2), ', ', num2str(pso.global_best{2})]);
                end
                
            end
        end

    end
    
end
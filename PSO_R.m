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
    end
   
    methods
        function pso = PSO_R(num_particles, num_iterations, ...
                inertia_factor, cog_factor, social_factor, joints_limits)
            pso.num_particles = num_particles;
            pso.num_iterations = num_iterations;
            pso.inertia_factor = inertia_factor;
            pso.cog_factor = cog_factor;
            pso.social_factor = social_factor;
            pso.joints_limits = joints_limits;

            pso.global_best = {[0, 0, 0, 0], inf};
        end

        function pso = init_particles(pso)
            for i = 1:pso.num_particles
                random_config = generate_r_config(pso.joints_limits);
                random_velocity = -1 + 1.5*rand(1, 4);
                new_particle = Particle(random_config, random_velocity, ...
                    pso.inertia_factor, pso.cog_factor, ...
                    pso.social_factor);
                pso.particles = [pso.particles, new_particle];
            end
        end

        function pso = optm_process(pso)
            for i = 1:pso.num_iterations
                disp(['------------ iteration ', num2str(i), ' ------------']);
                for j = 1:pso.num_particles
                    pso.particles(j) = pso.particles(j).update_velocity(pso.global_best);
                    pso.particles(j) = pso.particles(j).update_position;
                    pso.particles(j) = pso.particles(j).update_fitness;
                    
                    if pso.particles(j).fitness < pso.particles(j).own_best{2}
                        pso.particles(j).own_best = {pso.particles(j).position, ...
                                                    pso.particles(j).fitness};
                    end

                    if pso.particles(j).fitness < pso.global_best{2}
                        pso.global_best = {pso.particles(j).position, ...
                                            pso.particles(j).fitness};
                    end
                end
                disp(['global best for this iteration (position, fitness) => ', ...
                    mat2str(pso.global_best{1}, 2), ', ', num2str(pso.global_best{2})]);
            end
        end
        

        function pso = adjust_result(pso, initial_position)
            for i = 1:length(initial_position)
                pso.global_best{1}(i) = pso.global_best{1}(i) + initial_position(i);
            end
        end

    end
    
end
classdef environment
    properties
        child; robot; time; cube1; cube2; cube3; cube4;
    end
    
    methods
        function obj = environment()
            obj.time = 0;
            
            obj.child.head_angle = 0;
            obj.child.head_radius = 1.4;
            obj.child.head_pos = [0 3];
            obj.child.head_color = [0.95 0.95 1];
            obj.child.head_action_param = 0;
            obj.child.head_angle_des = -pi/2;
            
            obj.robot.head_angle_des = pi/2;
            obj.robot.head_angle = pi/4;
            obj.robot.head_radius = 1.4;
            obj.robot.head_pos = [0 -5];
            obj.robot.head_color = [1 1 1];
            obj.robot.bicep_length = 2.2;
            obj.robot.forearm_length = 1.6;
            obj.robot.shoulder_radius = 0.6; 
            obj.robot.elbow_radius = 0.5;
            obj.robot.fist_radius = 0.5;
            obj.robot.right_shoulder_pos = obj.robot.head_pos + [1.3*obj.robot.head_radius 0];
            obj.robot.left_shoulder_pos  = obj.robot.head_pos - [1.3*obj.robot.head_radius 0];
            
            obj.robot.right_arm_pos_rest = [obj.robot.head_radius, -3];
            obj.robot.right_arm_pos = obj.robot.right_arm_pos_rest;
            obj.robot.right_arm_pos_des = obj.robot.right_arm_pos;
            
            obj.robot.left_arm_pos_rest = [-obj.robot.head_radius, -3];
            obj.robot.left_arm_pos = obj.robot.left_arm_pos_rest;
            obj.robot.left_arm_pos_des = obj.robot.left_arm_pos;
            
            obj.robot.right_action_param = 0;
            obj.robot.left_action_param = 0;
            
            obj.robot.right_grasp = 0;
            obj.robot.left_grasp = 0;
            
            
            obj.robot.head_action_param = 0.5;

            obj.robot.pos0 = [0 -2.3];
            obj.robot.pos1 = [2 -1];
            obj.robot.pos2 = [0.8 -1.5];
            obj.robot.pos3 = [-1.3 -1];
            obj.robot.pos4 = [-3 -1];
            
            obj.cube1.pos = obj.robot.pos1;
            obj.cube1.color = [ 0 0 1 ];
            obj.cube1.size = 0.6;
            obj.cube1.grasped_right = 0;
            obj.cube1.grasped_left = 0;
            
            obj.cube2.pos = obj.robot.pos2;
            obj.cube2.color = [1 0 0];
            obj.cube2.size = 0.5;
            obj.cube2.grasped_right = 0;
            obj.cube2.grasped_left = 0;
            
            obj.cube3.pos = obj.robot.pos3;
            obj.cube3.color = [0.5 1 0.5];
            obj.cube3.size = 0.55;
            obj.cube3.grasped_right = 0;
            obj.cube3.grasped_left = 0;
            
            obj.cube4.pos = obj.robot.pos4;
            obj.cube4.color = [1 0.5 1];
            obj.cube4.size = 0.4;
            obj.cube4.grasped_right = 0;
            obj.cube4.grasped_left = 0;
            
        end
        
        function visualize(obj)
            drawstate(obj);
        end
        
        function obj = robotAction(obj, act, param)
            switch act
                case 1
                    actions = [0 1 2];
                    idx = randperm(3);
                    pos = actions(idx(1));
                    if pos==0
                        obj.robot.right_arm_pos_des = obj.robot.pos0;
                    elseif pos==1
                        obj.robot.right_arm_pos_des = obj.robot.pos1;
                        obj.robot.head_angle_des = atan2(obj.robot.pos1(2)-obj.robot.head_pos(2),obj.robot.pos1(1)-obj.robot.head_pos(1));
                    elseif pos==2
                        obj.robot.right_arm_pos_des = obj.robot.pos2;
                        obj.robot.head_angle_des = atan2(obj.robot.pos2(2)-obj.robot.head_pos(2),obj.robot.pos2(1)-obj.robot.head_pos(1));
                    end
                    obj.robot.right_action_param = param;
                case 2
                    obj.robot.right_arm_pos_des = obj.robot.right_arm_pos_rest;
                    obj.robot.right_action_param = param;
                    obj.robot.head_angle_des = pi/2;
                case 3
                    cubes = randperm(4);
                    cube = cubes(1);
                    if cube == 1
                        obj.robot.right_arm_pos_des = obj.cube1.pos;
                        vdes = obj.cube1.pos - obj.robot.right_shoulder_pos;
                        Ldes = norm(obj.cube1.pos - obj.robot.right_shoulder_pos);
                        L = obj.robot.bicep_length+obj.robot.forearm_length + 0.9*obj.robot.fist_radius;
                        if Ldes > L
                            obj.robot.right_arm_pos_des = obj.robot.right_shoulder_pos + vdes*L/Ldes;
                        end
                        obj.robot.head_angle_des = atan2(obj.cube1.pos(2)-obj.robot.head_pos(2),obj.cube1.pos(1)-obj.robot.head_pos(1));
                    elseif cube == 2
                        obj.robot.right_arm_pos_des = obj.cube2.pos;
                        vdes = obj.cube2.pos - obj.robot.right_shoulder_pos;
                        Ldes = norm(obj.cube2.pos - obj.robot.right_shoulder_pos);
                        L = obj.robot.bicep_length+obj.robot.forearm_length + 0.9*obj.robot.fist_radius;
                        if Ldes > L
                            obj.robot.right_arm_pos_des = obj.robot.right_shoulder_pos + vdes*L/Ldes;
                        end
                        obj.robot.head_angle_des = atan2(obj.cube2.pos(2)-obj.robot.head_pos(2),obj.cube2.pos(1)-obj.robot.head_pos(1));
                    elseif cube == 3
                        obj.robot.right_arm_pos_des = obj.cube3.pos;
                        vdes = obj.cube3.pos - obj.robot.right_shoulder_pos;
                        Ldes = norm(obj.cube3.pos - obj.robot.right_shoulder_pos);
                        L = obj.robot.bicep_length+obj.robot.forearm_length + 0.9*obj.robot.fist_radius;
                        if Ldes > L
                            obj.robot.right_arm_pos_des = obj.robot.right_shoulder_pos + vdes*L/Ldes;
                        end
                        obj.robot.head_angle_des = atan2(obj.cube3.pos(2)-obj.robot.head_pos(2),obj.cube3.pos(1)-obj.robot.head_pos(1));
                    elseif cube == 4
                        obj.robot.right_arm_pos_des = obj.cube4.pos;
                        vdes = obj.cube4.pos - obj.robot.right_shoulder_pos;
                        Ldes = norm(obj.cube4.pos - obj.robot.right_shoulder_pos);
                        L = obj.robot.bicep_length+obj.robot.forearm_length + 0.9*obj.robot.fist_radius;
                        if Ldes > L
                            obj.robot.right_arm_pos_des = obj.robot.right_shoulder_pos + vdes*L/Ldes;
                        end
                        obj.robot.head_angle_des = atan2(obj.cube4.pos(2)-obj.robot.head_pos(2),obj.cube4.pos(1)-obj.robot.head_pos(1));
                    end
                        obj.robot.left_action_param = param;
                case 4
                    actions = [0 3 4];
                    idx = randperm(3);
                    pos = actions(idx(1));
                    if pos==0
                        obj.robot.left_arm_pos_des = obj.robot.pos0;
                    elseif pos==3
                        obj.robot.left_arm_pos_des = obj.robot.pos3;
                        obj.robot.head_angle_des = atan2(obj.robot.pos3(2)-obj.robot.head_pos(2),obj.robot.pos3(1)-obj.robot.head_pos(1));
                    elseif pos==4
                        obj.robot.left_arm_pos_des = obj.robot.pos4;
                        obj.robot.head_angle_des = atan2(obj.robot.pos4(2)-obj.robot.head_pos(2),obj.robot.pos4(1)-obj.robot.head_pos(1));
                    end
                    obj.robot.right_action_param = param;
                case 5
                    obj.robot.left_arm_pos_des = obj.robot.left_arm_pos_rest;
                    obj.robot.left_action_param = param;
                    obj.robot.head_angle_des = pi/2;
                case 6
                    cubes = randperm(4);
                    cube = cubes(1);
                    if cube == 1
                        obj.robot.left_arm_pos_des = obj.cube1.pos;
                        vdes = obj.cube1.pos - obj.robot.left_shoulder_pos;
                        Ldes = norm(obj.cube1.pos - obj.robot.left_shoulder_pos);
                        L = obj.robot.bicep_length+obj.robot.forearm_length + 0.9*obj.robot.fist_radius;
                        if Ldes > L
                            obj.robot.left_arm_pos_des = obj.robot.left_shoulder_pos + vdes*L/Ldes;
                        end
                        obj.robot.head_angle_des = atan2(obj.cube1.pos(2)-obj.robot.head_pos(2),obj.cube1.pos(1)-obj.robot.head_pos(1));
                    elseif cube == 2
                        obj.robot.left_arm_pos_des = obj.cube2.pos;
                        vdes = obj.cube2.pos - obj.robot.left_shoulder_pos;
                        Ldes = norm(obj.cube2.pos - obj.robot.left_shoulder_pos);
                        L = obj.robot.bicep_length+obj.robot.forearm_length + 0.9*obj.robot.fist_radius;
                        if Ldes > L
                            obj.robot.left_arm_pos_des = obj.robot.left_shoulder_pos + vdes*L/Ldes;
                        end
                        obj.robot.head_angle_des = atan2(obj.cube2.pos(2)-obj.robot.head_pos(2),obj.cube2.pos(1)-obj.robot.head_pos(1));
                    elseif cube == 3
                        obj.robot.left_arm_pos_des = obj.cube3.pos;
                        vdes = obj.cube3.pos - obj.robot.left_shoulder_pos;
                        Ldes = norm(obj.cube3.pos - obj.robot.left_shoulder_pos);
                        L = obj.robot.bicep_length+obj.robot.forearm_length + 0.9*obj.robot.fist_radius;
                        if Ldes > L
                            obj.robot.left_arm_pos_des = obj.robot.left_shoulder_pos + vdes*L/Ldes;
                        end
                        obj.robot.head_angle_des = atan2(obj.cube3.pos(2)-obj.robot.head_pos(2),obj.cube3.pos(1)-obj.robot.head_pos(1));
                    elseif cube == 4
                        obj.robot.left_arm_pos_des = obj.cube4.pos;
                        vdes = obj.cube4.pos - obj.robot.left_shoulder_pos;
                        Ldes = norm(obj.cube4.pos - obj.robot.left_shoulder_pos);
                        L = obj.robot.bicep_length+obj.robot.forearm_length + 0.9*obj.robot.fist_radius;
                        if Ldes > L
                            obj.robot.left_arm_pos_des = obj.robot.left_shoulder_pos + vdes*L/Ldes;
                        end
                        obj.robot.head_angle_des = atan2(obj.cube4.pos(2)-obj.robot.head_pos(2),obj.cube4.pos(1)-obj.robot.head_pos(1));
                    end
                       obj.robot.left_action_param = param;
            end
        end
                
        
        function obj = step(obj)
            obj.time = obj.time+1;
            obj.robot.head_angle = (1-obj.robot.head_action_param)*obj.robot.head_angle + obj.robot.head_action_param*obj.robot.head_angle_des;
            obj.robot.right_arm_pos = (1-obj.robot.right_action_param)*obj.robot.right_arm_pos + obj.robot.right_action_param*obj.robot.right_arm_pos_des;
            obj.robot.left_arm_pos = (1-obj.robot.left_action_param)*obj.robot.left_arm_pos + obj.robot.left_action_param*obj.robot.left_arm_pos_des;
            
            if norm(obj.robot.right_arm_pos-obj.cube1.pos)<=0.01
                obj.cube1.grasped_right = 2*rand>0.5;
            elseif norm(obj.robot.right_arm_pos - obj.cube2.pos)<=0.01
                obj.cube2.grasped_right = 2*rand>0.5;
            elseif norm(obj.robot.right_arm_pos - obj.cube3.pos)<=0.01
                obj.cube3.grasped_right = round(rand);
            elseif norm(obj.robot.right_arm_pos - obj.cube4.pos)<=0.01
                obj.cube4.grasped_right = round(rand);
            end
            if obj.cube1.grasped_right==1
                obj.cube1.pos = obj.robot.right_arm_pos;
            end
            if obj.cube2.grasped_right==1
                obj.cube2.pos = obj.robot.right_arm_pos;
            end
            if obj.cube3.grasped_right==1
                obj.cube3.pos = obj.robot.right_arm_pos;
            end
            if obj.cube4.grasped_right==1
                obj.cube4.pos = obj.robot.right_arm_pos;
            end
            
            if norm(obj.robot.left_arm_pos-obj.cube1.pos)<=0.01 && obj.cube1.grasped_right==0
                obj.cube1.grasped_left = round(rand);
            elseif norm(obj.robot.left_arm_pos - obj.cube2.pos)<=0.01 && obj.cube2.grasped_right==0
                obj.cube2.grasped_left = round(rand);
            elseif norm(obj.robot.left_arm_pos - obj.cube3.pos)<=0.01 && obj.cube3.grasped_right==0
                obj.cube3.grasped_left = 2*rand>0.5;
            elseif norm(obj.robot.left_arm_pos - obj.cube4.pos)<=0.01 && obj.cube4.grasped_right==0
                obj.cube4.grasped_left = 2*rand>0.5;
            end
            
            if obj.cube1.grasped_left==1
                obj.cube1.pos = obj.robot.left_arm_pos;
            end
            if obj.cube2.grasped_left==1
                obj.cube2.pos = obj.robot.left_arm_pos;
            end
            if obj.cube3.grasped_left==1
                obj.cube3.pos = obj.robot.left_arm_pos;
            end
            if obj.cube4.grasped_left==1
                obj.cube4.pos = obj.robot.left_arm_pos;
            end
            
            if mod(obj.time, 10) == 1
                %p = [obj.cube1.pos; obj.cube2.pos; obj.cube3.pos; obj.cube4.pos; obj.robot.pos0];
                p = [obj.robot.right_arm_pos; obj.robot.left_arm_pos; obj.robot.pos0];
                idx = randperm(3);
                p = p(idx(1),:);
                obj.child.head_action_param = rand;
                obj.child.head_angle_des = atan2(p(2)-obj.child.head_pos(2), p(1)-obj.child.head_pos(1));
            end
            obj.child.head_angle = obj.child.head_action_param*obj.child.head_angle + (1-obj.child.head_action_param)*obj.child.head_angle_des;
            
            
        end
    end
end

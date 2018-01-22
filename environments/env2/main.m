clear; close all; clc;
addpath(genpath('./'));
load('T');

% create the environment with a Given Transition Matrix
env = environment(T);
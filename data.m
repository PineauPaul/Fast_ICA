[x,fs] = audioread('DDN3.mp3');
start_time = 0;
end_time = 10; %length of the records 
fs=44100 %44kHz 
Y_new=x((fs*start_time+1):fs*end_time,1);
audiowrite('DDN3.wav',Y_new,fs); %new records with same length and frequencie
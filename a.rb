#gem install open4
require "open4"

#COMPILE
pid, stdin, stdout, stderr = Open4::popen4 "g++ 1.cpp -o 1.o"

compile_err = stderr.gets #we need to save, it will changed

if compile_err.nil?
  puts "compiled"
else
  puts "CE\n#{compile_err}"
  abort()
end


#RUN
pid, stdin, stdout, stderr = Open4::popen4 "./ejudge-execute --time-limit=2 1.o"

verdict = stderr.gets
verdict = verdict[8] + verdict[9]

if verdict == "OK"
  puts "runs correctly"
else
  puts "#{verdict}"
  abort()
end


#CHECK(COMPARE)
pid, stdin, stdout, stderr = Open4::popen4 "./checkers/cmp_long_long_seq ./tests/input.txt output.txt ./tests/output.ans"
ignored, status = Process::waitpid2 pid

std_out = stdout.gets
std_err = stderr.gets

if status.exitstatus == 0
  puts "ACCEPTED"
elsif status.exitstatus == 4
  puts "Presentation Error"
elsif status.exitstatus == 5
  puts "Wrong Answer"
end
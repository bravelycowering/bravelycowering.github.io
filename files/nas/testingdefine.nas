define foo 123

#onJoin
msg foo: {foo}
set foo 456
msg foo: {foo}
resetdata packages
msg foo: {foo}
quit
@;=== startup function for ARM assembly programs ===

.text
		.arm
		.global _start
	_start:
		bl randomize		@; initizalize the seed of the random numbers
		bl principal		@; call the main routine
	.Lstop:
		b .Lstop			@; endless loop

.end

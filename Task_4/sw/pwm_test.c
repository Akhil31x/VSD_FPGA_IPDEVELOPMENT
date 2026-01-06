#define PWM_BASE 0x40001000
#define PWM_CTRL   (*(volatile unsigned int*)(PWM_BASE + 0x00))
#define PWM_PERIOD (*(volatile unsigned int*)(PWM_BASE + 0x04))
#define PWM_DUTY   (*(volatile unsigned int*)(PWM_BASE + 0x08))

void delay() {
    for (volatile int i = 0; i < 100000; i++);
}

int main() {
    PWM_PERIOD = 1000;
    PWM_CTRL   = 1;

    while (1) {
        PWM_DUTY = 100; delay();
        PWM_DUTY = 500; delay();
        PWM_DUTY = 900; delay();
    }
}

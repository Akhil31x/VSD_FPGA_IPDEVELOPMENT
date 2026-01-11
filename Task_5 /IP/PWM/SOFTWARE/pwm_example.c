/*
 * PWM Example Application
 *
 * This example demonstrates basic usage of the PWM IP.
 * The software configures the PWM period and duty cycle
 * using memory-mapped registers and enables the output.
 */

#define PWM_BASE   0x40001000

#define PWM_CTRL   (*(volatile unsigned int *)(PWM_BASE + 0x00))
#define PWM_PERIOD (*(volatile unsigned int *)(PWM_BASE + 0x04))
#define PWM_DUTY   (*(volatile unsigned int *)(PWM_BASE + 0x08))
#define PWM_STATUS (*(volatile unsigned int *)(PWM_BASE + 0x0C))

int main(void)
{
    /* Configure PWM period */
    PWM_PERIOD = 1000;

    /* Set duty cycle to 50% */
    PWM_DUTY = 500;

    /* Enable PWM */
    PWM_CTRL = 0x1;

    /* PWM runs continuously */
    while (1) {
        (void)PWM_STATUS;
    }

    return 0;
}

#include <stdio.h>

#define GPIO_BASE 0x2000_0000
#define GPIO_DATA (GPIO_BASE + 0x00)
#define GPIO_DIR  (GPIO_BASE + 0x04)
#define GPIO_READ (GPIO_BASE + 0x08)

volatile unsigned int *gpio_data_ptr = (volatile unsigned int *) GPIO_DATA;
volatile unsigned int *gpio_dir_ptr  = (volatile unsigned int *) GPIO_DIR;
volatile unsigned int *gpio_read_ptr = (volatile unsigned int *) GPIO_READ;

int main() {
    printf("\n=== GPIO Control IP Software Test ===\n");

    // Set all GPIO to output
    printf("\n[TEST 1] Setting GPIO_DIR to 0xFFFFFFFF\n");
    *gpio_dir_ptr = 0xFFFFFFFF;
    printf("GPIO_DIR = 0x%x\n", *gpio_dir_ptr);

    // Write data
    printf("\n[TEST 2] Writing 0x12345678 to GPIO_DATA\n");
    *gpio_data_ptr = 0x12345678;
    printf("GPIO_DATA = 0x%x\n", *gpio_data_ptr);
    printf("GPIO_READ = 0x%x\n", *gpio_read_ptr);

    // Change direction
    printf("\n[TEST 3] Setting GPIO_DIR to 0xFFFF0000\n");
    *gpio_dir_ptr = 0xFFFF0000;
    printf("GPIO_DIR = 0x%x\n", *gpio_dir_ptr);

    printf("\n=== All software tests complete ===\n");
    return 0;
}

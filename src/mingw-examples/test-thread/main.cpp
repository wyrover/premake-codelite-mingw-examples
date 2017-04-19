#include <iostream>
#include <chrono>
#include <thread>
#include <mutex>

/**
 *  Threads and mutex.
 *  Comment mutexerino.lock and unlock to see thread unsafe behavior.
 */

std::mutex mutexerino;

void threaderinoFunc(int& sleep)
{
    for (int i = 0; i < 50; i++) {
        mutexerino.lock();
        std::cout << "Thread " << std::this_thread::get_id() << ": " << i << std::endl;
        mutexerino.unlock();
        std::this_thread::sleep_for(std::chrono::milliseconds(sleep));
    }
}

int main()
{
    // Display Program introduction.
    std::cout << "Main Thread Start, GCC Version: " << __VERSION__ << std::endl;
    // Starts 2 threads that use the same function.
    std::thread threaderino(threaderinoFunc, std::move(5)),
        threaderino2(threaderinoFunc, std::move(5));
    // Wait/Make sure the threads are over before exiting the program.
    threaderino.join();
    threaderino2.join();
    // Exits program
    return 0;
}
#include <regex>
#include <iostream>
#include <string>

int main()
{
    // Vars
    int n, t;
    std::regex reg("\bfoo\b");
    std::smatch matches;
    // Input number of sentences
    std::cin >> n;
    std::cin.ignore(256, '\n');
    // Sentences declaration
    std::string sentences[n];

    // Get lines
    for (int i = 0; i < n; i++) {
        std::getline(std::cin, sentences[i]);
    }

    // Input number of word lines
    std::cin >> t;
    std::cin.ignore(256, '\n');
    // Words declaration
    std::string words[t];

    // Get lines
    for (int i = 0; i < t; i++) {
        std::getline(std::cin, words[i]);
    }

    // Regex
    regex_match(sentences[0], matches, reg);
    // Print n of matches
    std::cout << matches.size();
    return 0;
}
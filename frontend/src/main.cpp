
#include <iostream>
#include <filesystem>
#include <fstream>
#include <cstdlib>
#include <string>

namespace fs = std::filesystem;

int run_cmd(const std::string &cmd) {
#ifdef _WIN32
    return system(cmd.c_str());
#else
    return system(cmd.c_str());
#endif
}

std::string run_capture(const std::string &cmd) {
    std::string data;
#ifdef _WIN32
    FILE* pipe = _popen(cmd.c_str(), "r");
#else
    FILE* pipe = popen(cmd.c_str(), "r");
#endif
    if (!pipe) return "";
    char buffer[256];
    while (fgets(buffer, sizeof(buffer), pipe)) data += buffer;
#ifdef _WIN32
    _pclose(pipe);
#else
    pclose(pipe);
#endif
    return data;
}

std::string detect_default_branch() {
    std::string info = run_capture("git remote show origin 2>nul");
    if (info.find("HEAD branch: master") != std::string::npos) return "master";
    if (info.find("HEAD branch: main") != std::string::npos) return "main";
    return "main";
}

void ensure_gitignore(const fs::path &p) {
    fs::path gi = p / ".gitignore";
    if (!fs::exists(gi)) {
        std::ofstream f(gi);
        f << "node_modules/\n";
        f.close();
    }
}

int main(int argc, char** argv) {
    if (argc < 2) {
        std::cerr << "Usage: sync2github <folder> --repo=<user/repo> [--branch=<name>] [--message=<msg>]\n";
        return 1;
    }
    std::string folder = argv[1];
    std::string repo, branch = "develop", msg = "Mise à jour automatique";

    for (int i = 2; i < argc; ++i) {
        std::string arg = argv[i];
        if (arg.rfind("--repo=",0)==0) repo = arg.substr(7);
        else if (arg.rfind("--branch=",0)==0) branch = arg.substr(9);
        else if (arg.rfind("--message=",0)==0) msg = arg.substr(10);
    }
    if (repo.empty()) { std::cerr << "Missing --repo=<user/repo>\n"; return 1; }

    fs::path dir(folder);
    if (!fs::exists(dir)) { std::cerr << "Folder not found: " << folder << "\n"; return 1; }

    ensure_gitignore(dir);
    fs::current_path(dir);

    if (!fs::exists(".git")) {
        std::string url = "https://github.com/" + repo + ".git";
        std::cout << "Cloning " << url << std::endl;
        run_cmd(("git clone " + url + " .").c_str());
    }

    std::string mainBranch = detect_default_branch();
    run_cmd(("git fetch origin " + mainBranch).c_str());
    run_cmd(("git checkout -B " + branch + " origin/" + mainBranch).c_str());

    run_cmd("git pull origin " + branch);
    run_cmd("git add .");
    std::string commit = "git commit -m \"" + msg + "\"";
    run_cmd(commit.c_str());
    run_cmd(("git push origin " + branch).c_str());

    std::cout << "✅ Synchronisation terminee sur la branche " << branch << std::endl;
    return 0;
}

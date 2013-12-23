# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :game_file do
    game
    file_dir "file_dir"
    exe_path_name "exe_path_name"
    crypt_type 1
    patch_ver 0
    game_shell "game_shell"
    shell_ver 1
    shell_digest "shell_digest"
    game_ini "game_ini"
    ini_ver 1
    ini_digest "ini_digest"
    status GameFile::STATUS_VALIDATED
  end
end

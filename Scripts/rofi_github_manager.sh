#!/bin/bash

# Rofi ile seçim yapma fonksiyonu
rofi_menu() {
    # echo -e "$1" | rofi -dmenu -p "$2"
    echo -e "$1" | rofi -dmenu -i -theme "$HOME/.config/rofi/launchers/type-3/style-github-5.rasi" -p "$2"
}

# Rofi ile şifre girişi alma (karakterleri gizleme)
rofi_password() {
    rofi -dmenu -i -theme "$HOME/.config/rofi/launchers/type-3/style-github-5.rasi" -password -p "$1" 
}

# Rofi ile ana menüyü aç
selectOperation() {
    choice=$(rofi_menu "Add Repository\nDelete Repository\nExit" "Choose:")
    
    case $choice in
        "Delete Repository")
            deleteRepository
            ;;
        "Add Repository")
            addRepository
            ;;
        "Exit")
            exit 0
            ;;
        *)
            notify-send "Invalid Choice" "Please try again."
            ;;
    esac
}

deleteRepository() {
    userName=$(rofi_menu "" "GitHub User Name:")
    authKey=$(rofi_password "GitHub Password:")
    
    # Repo listesini al
    repoList=$(curl -s -H "Authorization: Bearer $authKey" "https://api.github.com/users/$userName/repos")
    if [ -z "$repoList" ] || [ "$(echo "$repoList" | jq -r 'type')" != "array" ]; then
        notify-send "Error" "Invalid GitHub Username or Authorization Token."
        return
    fi

    # Kullanıcının repo listesini al ve çoklu seçim yaptır
    selectedRepos=$(echo "$repoList" | jq -r '.[].name' | rofi -dmenu -multi-select -ballot-selected-str " " -ballot-unselected-str "󰳐 " -theme "$HOME/.config/rofi/launchers/type-3/style-github-5.rasi" -p "Select Repositories:")
    
    if [ -z "$selectedRepos" ]; then
        notify-send "Error" "No repository selected or authentication failed."
        return
    fi

    # Silinecek repoların özet listesini hazırla
    # repoSummary=$(echo "$selectedRepos" | sed 's/^/- /')

# repoSummary=$(echo "$selectedRepos" | sed 's/^/ /')


    # Kullanıcıya seçilen repoları göstererek onay al
    # repoSummary=$(echo "$selectedRepos" | sed 's/^/ /')
    # confirmation=$(rofi_menu "Yes\nNo" "$repoSummary Are you sure you want to delete it ?")

    repoSummary=$(echo "$selectedRepos" | sed 's/^/ /')
    confirmation=$(rofi_menu "Yes\nNo" "$(printf "%s\n%s" "$repoSummary" "Are you sure you want to delete it ?")")


    
    if [ "$confirmation" != "Yes" ]; then
        notify-send "Canceled" "Operation aborted."
        return
    fi

    # Seçilen her repo için silme işlemi yap
    echo "$selectedRepos" | while read -r repo; do
        response=$(curl -s -o /dev/null -w "%{http_code}" \
            -X DELETE \
            -H "Authorization: Bearer $authKey" \
            "https://api.github.com/repos/$userName/$repo")

        if [ "$response" -eq 204 ]; then
            notify-send "Success" "Repository '$repo' has been deleted."
        else
            notify-send "Error" "Failed to delete repository '$repo'. HTTP code: $response"
        fi
    done
}


# Rofi ile yeni repo ekleme
addRepository() {
    authKey=$(rofi_password "GitHub Password:")
    
    # Auth kontrolü
    repoList=$(curl -s -H "Authorization: Bearer $authKey" "https://api.github.com/user/repos")
    if [ -z "$repoList" ] || [ "$(echo "$repoList" | jq -r 'type')" != "array" ]; then
        notify-send "Error" "Invalid Authorization Token."
        return
    fi

    # Kullanıcıdan repo bilgilerini al
    newRepoName=$(rofi_menu "" "Repository Name:")
    description=$(rofi_menu "" "Repository Description:")
    isPrivate=$(rofi_menu "true\nfalse" "Is Private?")

    # Yeni repo oluştur
    response=$(curl -s -o /dev/null -w "%{http_code}" \
        -X POST \
        -H "Accept: application/vnd.github+json" \
        -H "Authorization: Bearer $authKey" \
        -H "X-GitHub-Api-Version: 2022-11-28" \
        -d "{\"name\":\"$newRepoName\",\"description\":\"$description\",\"private\":$isPrivate}" \
        "https://api.github.com/user/repos")

    if [ "$response" -eq 201 ]; then
        notify-send "Success" "Repository '$newRepoName' was created."
    else
        notify-send "Error" "Failed to create repository. HTTP Code: $response"
    fi
}

selectOperation

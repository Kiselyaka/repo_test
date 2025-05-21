# Задаём новые данные для автора коммитов
$NewAuthorName = "Kiselyaka"
$NewAuthorEmail = "kiselyaka12s@gmail.com"

# Получаем все локальные ветки, кроме main и master
$branches = git branch --format="%(refname:short)" | Where-Object { $_ -ne "main" -and $_ -ne "master" }

foreach ($branch in $branches) {
    $newBranch = "new-$branch"

    Write-Host "`n--- Обработка ветки: $branch ---"

    # Переключаемся на ветку
    git checkout $branch

    # Переписываем все коммиты в текущей ветке с новым автором
    git filter-branch --env-filter "
    export GIT_AUTHOR_NAME='$NewAuthorName'
    export GIT_AUTHOR_EMAIL='$NewAuthorEmail'
    export GIT_COMMITTER_NAME='$NewAuthorName'
    export GIT_COMMITTER_EMAIL='$NewAuthorEmail'
    " -- --all

    # Переименовываем ветку
    git branch -m $newBranch
    Write-Host "Переименована в: $newBranch"

    # Удаляем старую ветку на origin (если была)
    git push origin --delete $branch 2>$null

    # Пушим новую ветку
    git push origin $newBranch

    # Устанавливаем слежение
    git push --set-upstream origin $newBranch
}

# Форс-пуш всех веток на удалённый репозиторий (перезаписать историю)
git push origin --force --all
git push origin --force --tags

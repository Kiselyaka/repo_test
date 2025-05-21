# Получаем все локальные ветки, кроме main и master
$branches = git branch --format="%(refname:short)" | Where-Object { $_ -ne "main" -and $_ -ne "master" }

foreach ($branch in $branches) {
    $newBranch = "new-$branch"

    # Переименовываем ветку
    git branch -m $branch $newBranch

    # Удаляем старую ветку на origin, если существует
    git push origin --delete $branch 2>$null

    # Пушим новую ветку
    git push origin $newBranch

    # Устанавливаем upstream
    git push --set-upstream origin $newBranch
}

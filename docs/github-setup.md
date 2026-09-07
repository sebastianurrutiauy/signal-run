# Publicar y trabajar en GitHub

## Primera publicación

1. Crea un repositorio vacío en GitHub, por ejemplo `signal-run`.
2. Abre esta carpeta con una terminal y ejecuta:

```powershell
git init
git add .
git commit -m "chore: create Godot starter"
git branch -M main
git remote add origin https://github.com/TU-USUARIO/signal-run.git
git push -u origin main
```

3. Invita a tu amigo desde **Settings → Collaborators**.
4. En **Settings → Branches**, crea una regla para `main`: exige pull request y una aprobación antes de fusionar.

## Ritmo sugerido

Al inicio de la semana definan 3–5 Issues pequeños. El desarrollador mueve uno a “En progreso”, abre un PR y el QA lo prueba con la checklist de ese PR. Los bugs encontrados se registran como Issues separados, vinculados al PR si corresponde.

Para la primera entrega, prueben una build desde cero en una máquina distinta a la de desarrollo. Esa prueba encuentra problemas de exportación, rutas de archivos y controles que no suelen aparecer durante la implementación.

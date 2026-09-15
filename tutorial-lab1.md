<walkthrough-tutorial-url url="https://github.com/DevOps-Playbook/MERN-Stack-Application"></walkthrough-tutorial-url>
<walkthrough-tutorial-difficulty difficulty="1"></walkthrough-tutorial-difficulty>
<walkthrough-tutorial-duration duration="15"></walkthrough-tutorial-duration>

# Run WanderLust (MERN Stack) with Docker Compose

## Welcome

In this lab you'll containerize and run **WanderLust**, a MERN-stack travel blog app,
entirely inside Cloud Shell using Docker Compose. No local setup required — everything
runs in this cloud terminal.

By the end you'll have:
- The backend (Node/Express API) running in a container
- The frontend (React/Vite) running in a container
- MongoDB running in a container, seeded with sample data
- The live app open in your browser via Cloud Shell Web Preview

Click **Start** to begin.

## Step 1: Confirm the repo is cloned

Cloud Shell should have already cloned this repository for you into
`~/cloudshell_open/MERN-Stack-Application`. Confirm you're in the right place:

```bash
cd ~/cloudshell_open/MERN-Stack-Application && ls
```

## Step 2: Set up environment variables

Both services ship with sample env files. Copy them so Docker Compose can pick them up:

```bash
cat backend/.env.docker
cat frontend/.env.docker
```

<walkthrough-editor-open-file filePath="MERN-Stack-Application/backend/.env">
Open the backend .env file
</walkthrough-editor-open-file>

Take a quick look — for this lab the defaults are fine since Docker Compose wires the
containers together on an internal network.

## Step 3: Build and start the stack

This single command builds the backend and frontend images and starts Mongo alongside them:

```bash
docker compose up -d
```

This can take a couple of minutes on the first run while images build. Check that all
three containers are up:

```bash
docker compose ps
```

You should see three services in an `Up`/`running` state.

## Step 4: Load sample data into MongoDB

The app needs sample blog posts to display anything interesting. Import them straight
into the running Mongo container:

```bash
docker exec -it mongo mongoimport --db wanderlust --collection posts --file /data/sample_posts.json --jsonArray
```

> If your Mongo container name differs, check it with `docker ps` and substitute it above.

## Step 5: View the app

WanderLust's frontend listens on port 5173. Use Cloud Shell's **Web Preview** to open it:

1. Click the Web Preview icon (top-right of the Cloud Shell toolbar)
2. Select **Preview on port 5173**

<walkthrough-web-preview-icon></walkthrough-web-preview-icon>

You should see the WanderLust travel blog homepage, loaded with sample posts.

## Step 6: Check the backend logs (optional but recommended)

While the frontend is open, tail the backend logs in a split terminal to see API
requests come through as you click around:

```bash
docker compose logs -f backend
```

Press `Ctrl+C` to stop tailing.

## Step 7: Clean up

When you're done with the lab, tear everything down so it doesn't keep using
Cloud Shell's resources:

```bash
docker compose down
```
* Removes all unused volumes, images & networks

```bash
docker system prune -a --volumes -f
```


## Congratulations 🎉

<walkthrough-conclusion-trophy></walkthrough-conclusion-trophy>

You've deployed a full MERN stack application using Docker Compose
Ready for the next lab? Head back to the course site to continue.

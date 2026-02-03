<script>
  import { onMount } from 'svelte'

  let isOpen = false
  let role = 'moderator'
  let panels = []
  let permissions = []
  let players = []
  let search = ''
  let selectedPlayer = null
  let toast = null

  const categories = () => {
    const map = new Map()
    panels.forEach((panel) => {
      if (!map.has(panel.category)) {
        map.set(panel.category, [])
      }
      map.get(panel.category).push(panel)
    })
    return [...map.entries()]
  }

  const filteredPanels = (list) =>
    list.filter((panel) => panel.label.toLowerCase().includes(search.toLowerCase()))

  const sendAction = (panel, payload = {}) => {
    fetch(`https://${GetParentResourceName()}/action`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ panel, target: selectedPlayer?.id, ...payload })
    })
  }

  const closeMenu = () => {
    fetch(`https://${GetParentResourceName()}/close`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' }
    })
  }

  const quickPanel = (panel) => permissions.includes(panel)

  const setToast = (message, type = 'info') => {
    toast = { message, type }
    setTimeout(() => (toast = null), 3500)
  }

  onMount(() => {
    window.addEventListener('message', (event) => {
      const { action, data } = event.data
      if (action === 'open') {
        isOpen = true
        role = data.role
        permissions = data.permissions || []
        panels = data.panels || []
        players = data.players || []
        selectedPlayer = players[0] || null
      }
      if (action === 'players') {
        players = data || []
        if (!selectedPlayer && players.length) {
          selectedPlayer = players[0]
        }
      }
      if (action === 'toast') {
        setToast(data.message, data.type)
      }
    })
  })
</script>

{#if isOpen}
  <div class="admin-root">
    <aside class="sidebar">
      <header>
        <h1>Ultimate Admin</h1>
        <p class="role">Role: {role}</p>
      </header>
      <input
        class="search"
        type="text"
        placeholder="Search panels"
        bind:value={search}
      />
      <div class="players">
        <h3>Players</h3>
        <div class="player-list">
          {#each players as player}
            <button
              class:selected={selectedPlayer?.id === player.id}
              on:click={() => (selectedPlayer = player)}
            >
              <span>{player.name}</span>
              <small>{player.job}</small>
            </button>
          {/each}
        </div>
      </div>
      <div class="quick">
        <h3>Quick Actions</h3>
        <div class="quick-actions">
          {#if quickPanel('noclip')}
            <button on:click={() => sendAction('noclip')}>No-clip</button>
          {/if}
          {#if quickPanel('spectate')}
            <button on:click={() => sendAction('spectate')}>Spectate</button>
          {/if}
          {#if quickPanel('freeze')}
            <button on:click={() => sendAction('freeze')}>Freeze</button>
          {/if}
          {#if quickPanel('revive')}
            <button on:click={() => sendAction('revive')}>Revive</button>
          {/if}
          {#if quickPanel('heal')}
            <button on:click={() => sendAction('heal')}>Heal</button>
          {/if}
          {#if quickPanel('kick')}
            <button on:click={() => sendAction('kick')}>Kick</button>
          {/if}
        </div>
      </div>
      <button class="close" on:click={closeMenu}>Close</button>
    </aside>
    <main class="content">
      {#each categories() as [category, items]}
        <section>
          <h2>{category}</h2>
          <div class="panel-grid">
            {#each filteredPanels(items) as panel}
              <button
                class="panel"
                on:click={() => sendAction(panel.id)}
              >
                <span>{panel.label}</span>
                <small>{panel.id}</small>
              </button>
            {/each}
          </div>
        </section>
      {/each}
    </main>
    {#if toast}
      <div class={`toast ${toast.type}`}>{toast.message}</div>
    {/if}
  </div>
{/if}

<style>
  :global(body) {
    margin: 0;
    font-family: 'Inter', sans-serif;
    background: transparent;
    color: #e8e8f0;
  }

  .admin-root {
    display: grid;
    grid-template-columns: 320px 1fr;
    height: 100vh;
    background: radial-gradient(circle at top, rgba(42, 45, 66, 0.9), rgba(10, 10, 18, 0.95));
  }

  .sidebar {
    padding: 24px;
    display: flex;
    flex-direction: column;
    gap: 20px;
    background: rgba(15, 16, 25, 0.95);
    border-right: 1px solid rgba(255, 255, 255, 0.08);
  }

  header h1 {
    margin: 0;
    font-size: 22px;
  }

  .role {
    margin: 4px 0 0;
    font-size: 12px;
    color: #a3a5c6;
  }

  .search {
    padding: 10px 12px;
    border-radius: 10px;
    border: none;
    background: rgba(255, 255, 255, 0.08);
    color: #e8e8f0;
  }

  .players {
    flex: 1;
    overflow: hidden;
  }

  .player-list {
    display: grid;
    gap: 8px;
    max-height: 220px;
    overflow: auto;
  }

  .player-list button {
    display: flex;
    justify-content: space-between;
    padding: 8px 10px;
    border-radius: 8px;
    background: rgba(255, 255, 255, 0.06);
    border: 1px solid transparent;
    color: inherit;
    cursor: pointer;
  }

  .player-list button.selected {
    border-color: #6d7dff;
    background: rgba(109, 125, 255, 0.2);
  }

  .quick-actions {
    display: grid;
    grid-template-columns: repeat(2, 1fr);
    gap: 8px;
  }

  .quick-actions button,
  .panel,
  .close {
    padding: 10px 12px;
    border-radius: 10px;
    border: none;
    background: rgba(109, 125, 255, 0.2);
    color: inherit;
    cursor: pointer;
  }

  .content {
    padding: 32px;
    overflow: auto;
  }

  .panel-grid {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(180px, 1fr));
    gap: 12px;
  }

  section h2 {
    margin: 24px 0 12px;
    color: #cbd2ff;
  }

  .panel {
    text-align: left;
    background: rgba(20, 22, 34, 0.75);
    border: 1px solid rgba(255, 255, 255, 0.08);
  }

  .panel small {
    display: block;
    font-size: 11px;
    color: #8c8fb3;
  }

  .toast {
    position: absolute;
    right: 24px;
    bottom: 24px;
    padding: 12px 16px;
    background: rgba(20, 22, 34, 0.9);
    border-radius: 10px;
    border-left: 4px solid #6d7dff;
  }

  .toast.error {
    border-left-color: #ff6d6d;
  }

  @media (max-width: 900px) {
    .admin-root {
      grid-template-columns: 1fr;
    }
    .sidebar {
      flex-direction: row;
      flex-wrap: wrap;
    }
  }
</style>

import { createRoot } from 'react-dom/client'
import App from './App'
import HrmContext from './Context/HrmContext'
import RouterContext from './Context/RouterContext'
createRoot(document.getElementById('root')).render(
    <RouterContext>
        <HrmContext>
            <App>
            </App>
        </HrmContext>
    </RouterContext>

)

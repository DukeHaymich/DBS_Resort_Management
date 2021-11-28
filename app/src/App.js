import Main from './main/Main';
import { DBHelperProvider }  from './main/helpers/DBHelper';
function App() {
  return (
    <div className="App">
      <DBHelperProvider>
      <Main/>
      </DBHelperProvider>
    </div>
  );
}

export default App;
